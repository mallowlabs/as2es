as2es
===================

Overview
----------------

Data transfer script from AsakusaSatellite to ElasticSearch.

Authors
----------------

 * @mallowlabs

Requirement
----------------

 * Ruby 2.0.0

Install
----------------

Install dependencies:

    $ bundle install --path .bundle

Run:

    $ export ELASTICSEACH_URL=http://elastic-search-host:9200
    $ export ASAKUSA_SATELLITE_ENTRY_POINT=http://asakusa-satellite-host/api/v1/
    $ export ASAKUSA_SATELLITE_ROOM_ID=your-room-id
    $ export ASAKUSA_SATELLITE_API_KEY=your-api-key
    $ bundle exec ruby as2es.rb


