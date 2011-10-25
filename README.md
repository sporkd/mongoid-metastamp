Mongoid Metastamp
=========================

Provides Mongoid with enhanced meta-timestamps that store additional parsed time metadata,
allowing more powerful querying on specific time fields and across normalized time zones.


What It Does
=========================
(Or why would I want to use this?)

Storing simple timestamps is all well and good if your queries are simple or involve just one timezone.
But sometimes you need to search for each timestamp relative to the timezone it was created in.
This is common when you have more than one location. For example:

* Find all flights that depart from all airports between 1:00pm and 2:00pm local (airport) time.
* Return all employees that clocked in later than 8:00am local time to any of our nationwide locations.

Other times you want to be able to query very specific parts of the
date or time that typically can't be accessed without parsing it:

* Find all transactions that occurred on weekdays after 12pm in 2010.
* Return all users that signed up the first week of every month over the last 3 years.

Typically to do these things, you'd need to add a bunch of of complex time ranges to your query.
Or you might query the entire range and loop through each result, running additional tests on the parsed time.

Using mongoid-metastamp gives you a custom time field type that is normalized and parsed beforehand,
and then stored in a MongoDB friendly way for easy querying.


Installation
=========================

In your Gemfile

```
gem 'mongoid-metastamp'
```

```
$ bundle install
```

Usage
=========================

For the most part, `Mongoid::Metastamp::Time` fields can be used just like regular `Time` fields:

```ruby
class MyEvent
  include Mongoid::Document
  field :starts_at, type: Mongoid::Metastamp::Time
  field :ends_at,   type: Mongoid::Metastamp::Time
end
```

```ruby
event = MyEvent.new
event.starts_at = Time.now
event.ends_at = Time.now + 1.day
event.save
# => true

event.starts_at
# => Wed, 5 Oct 2011 20:46:22 UTC +00:00
event.ends_at
# => Thu, 6 Oct 2011 20:46:31 UTC +00:00
```


Data Stored
=========================

However, behind the scenes the following meta fields will transparently be stored inside
your Mongoid::Metastamp::Time field:

* `time` (Date)
* `normalized` (Date)
* `year` (Int)
* `month` (Int)
* `day` (Int)
* `wday` (Int)
* `hour` (Int)
* `min` (Int)
* `sec` (Int)
* `zone` (String)
* `offset` (Int)


So given a field named `timestamp`:

```ruby
class MyEvent
  include Mongoid::Document
  field :timestamp, type: Mongoid::Metastamp::Time
end
```

You can access the raw metadata fields like this:

```ruby
event = MyEvent.new(timestamp: "2011-10-05 10:00:00 -0800")

event['timestamp']
# => {"time"=>2011-10-05 17:00:00 UTC, "normalized"=>2011-10-05 10:00:00 UTC, "year"=>2011, "month"=>10, "day"=>5, "wday"=>3, "hour"=>10, "min"=>0, "sec"=>0, "zone"=>"-08:00", "offset"=>-25200}

event['timestamp']['month']  # => 10
event['timestamp']['day']    # => 5
event['timestamp']['year']   # => 2011
event['timestamp']['zone']   # => "-08:00"
```

The `time` meta-field is special and stores whatever you assign the field to.

```ruby
event['timestamp']['time']
# => 2011-10-05 17:00:00 UTC
```

It will also be the value deserialized when you access the `timestamp` field.

```ruby
event.timestamp
# => Wed, 05 Oct 2011 17:00:00 UTC +00:00
```

The `normalized` meta-field is the time normalized to a UTC value.
This is useful when you want to query ignoring local offsets.

```ruby
eastern_event = MyEvent.new(timestamp: "2011-10-05 10:00:00 -0400")
pacific_event = MyEvent.new(timestamp: "2011-10-05 10:00:00 -0800")

eastern_event['timestamp']['time']        # => 2011-10-05 14:00:00 UTC
eastern_event['timestamp']['normalized']  # => 2011-10-05 10:00:00 UTC

pacific_event['timestamp']['time']        # => 2011-10-05 17:00:00 UTC
pacific_event['timestamp']['normalized']  # => 2011-10-05 10:00:00 UTC
```


Querying
=========================

Since the `time` meta-field is the default, it can be queried as `timestamp`:

```ruby
good_old_days = Day.where(:timestamp.lt => 20.years.ago)
```

or as `timestamp.time`:

```ruby
good_old_days = Day.where("timestamp.time" => { '$lt' => 20.years.ago })
```

For now, the other meta-fields need to be queried using the longer syntax:

```ruby
hump_days = Day.where("timestamp.wday" => 5)
# => Only Wednesdays

afternoon_delights = Delight.where("timestamp.hour" => { '$gte' => 12, '$lt' => 15 })
# => Only between 12pm and 3pm
```
See the [search specs](https://github.com/sporkd/mongoid-metastamp/blob/master/spec/time_search_spec.rb)
for more examples.


Todo
======

* Add custom finder methods and scopes
* Migration task to convert existing time fields
* Additional field types


License
========

Copyright (c) 2011 Peter Gumeson.
See [LICENSE](https://github.com/sporkd/mongoid-metastamp/blob/master/LICENSE) for full license.

