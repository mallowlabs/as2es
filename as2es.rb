#! /user/bin/env ruby
# -*- mode:ruby; coding:utf-8 -*-

require 'json'
require 'open-uri'
require "elasticsearch"
require 'pp'

ELASTICSEACH_URL = ENV['ELASTICSEACH_URL']
es = Elasticsearch::Client.new(url: ELASTICSEACH_URL)
es.indices.create index: "messages", body: {
#  settings: {
#    analysis: {
#      analyzer: {
#        kuromoji_analyzer: {
#          type: "custom",
#          tokenizer: "kuromoji_tokenizer",
#          filter: ["kuromoji_baseform", "cjk_width"]}}}},
  mappings: {
    default: {
      _id: {path: "id"},
      _timestamp: {enabled: true, path: "created_at"},
      _source: {enabled: true},
      _all: {enabled: true }, #, analyzer: "kuromoji_analyzer"},
      properties: {
        id: {type: "string", include_in_all: false, store: true},
        screen_name: {type: "string", index: "not_analyzed", store: true},
        body: {type: "string", store: true, index: "analyzed"}, #, analyzer: "kuromoji_analyzer"},
        created_at: {type: "date", include_in_all: false, store: true}}}}}

ASAKUSA_SATELLITE_ENTRY_POINT = ENV["ASAKUSA_SATELLITE_ENTRY_POINT"]
ASAKUSA_SATELLITE_API_KEY = ENV["ASAKUSA_SATELLITE_API_KEY"]
ASAKUSA_SATELLITE_ROOM_ID = ENV["ASAKUSA_SATELLITE_ROOM_ID"]
COUNT = 50

since_id = nil

100.times do
  url = "#{ASAKUSA_SATELLITE_ENTRY_POINT}/message/list.json"
  url += "?api_key=#{ASAKUSA_SATELLITE_API_KEY}"
  url += "&room_id=#{ASAKUSA_SATELLITE_ROOM_ID}"
  url += "&order=desc"
  url += "&count=#{COUNT}"
  url += "&older_than=#{since_id}" if since_id

  messages = []
  begin
    open(url) do |f|
      messages = JSON.load(f).map { |m| {
                 id: m["id"],
        screen_name: m["screen_name"],
         created_at: m["created_at"].split[0..1].join("T"),
               body: m["body"]
      } }
    end
  rescue => e
    warn e
  end

  messages.each do |message|
    pp message
    es.index index: "messages", type: "default", body: message
    since_id = messages.last[:id]
  end

end
