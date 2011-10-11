Mongoid Metastamp
=========================

Provides Mongoid with enhanced meta-timestamps that store additional parsed time metadata,
allowing more powerful querying on specific time fields and across normalized time zones.


What It Does
=========================
(Or why would I want to use this?)

Storing simple timestamps is all well and good if your queries are simple or involve just one timezone.
But sometimes you need to search across multiple locations while
ignoring timezone offsets. For example:

* Find all flights that depart from any airport between 1:00pm and 2:00pm local time.
* Return all employees that clocked in after 8:00am at either the Denver or San Diego location.

Other times you want to be able to query very specific parts of the
date/time that typically can't be accessed without parsing it:

* Find all transactions that occured on weekday afternoons in 2011.
* Return all users that signed up in January for the last 3 years.

Typically to do these things, you'd need to add a bunch of of complex time ranges to your query.
Or you might query the entire range and loop through each result, running additional tests on the parsed time.

Using mongoid-metastamp gives you a custom time field type that is normalized beforehand,
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
MyEvent.create(starts_at: Time.now, ends_at: Time.now + 1.day)

event = MyEvent.where(:starts_at.lt => Time.now, :ends_at.gt => Time.now).one
event.starts_at  # => Time
event.ends_at    # => Time
```

Data Stored
=========================

When you define a `Mongoid::Metastamp::Time` field, the following meta fields also get stored inside its hash:

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


The `time` meta-field stores whatever you assign the field to.
It will also be the value deserialized when you access the field.

```ruby
field :timestamp, type: Mongoid::Metastamp::Time
```

For a field called `timestamp`, you can access the raw metadata fields like this:

```ruby
event = MyEvent.new(starts_at: "2011-10-05 10:00:00 -0700")
event['timestamp']['month']  # => 10
event['timestamp']['day']    # => 5
event['timestamp']['year']   # => 2011
event['timestamp']['zone']   # => "-07:00"
```

The `normalized` meta-field is the time normalized to a UTC value.
This is useful when you want to query ignoring local offsets.

```ruby
eastern_event = MyEvent.new(timestamp: "2011-10-05 10:00:00 -0400")
pacific_event = MyEvent.new(timestamp: "2011-10-05 10:00:00 -0700")

eastern_event['timestamp']['time']        # => 2011-10-05 14:00:00 UTC
eastern_event['timestamp']['normalized']  # => 2011-10-05 10:00:00 UTC

pacific_event['timestamp']['time']        # => 2011-10-05 17:00:00 UTC
pacific_event['timestamp']['normalized']  # => 2011-10-05 10:00:00 UTC
```


Querying
=========================

Since the `time` meta-field is the default, it can be queried as either `timestamp` or `timestamp.time`:

```ruby
good_old_days = Day.where(:timestamp.lt => 20.years.ago)
```

or...

```ruby
good_old_days = Day.where("timestamp.time" => { '$lt' => 20.years.ago })
```

The other meta-fields need to be queried with the full syntax:

```ruby
hump_days = Day.where("timestamp.wday" => 5)
=> Only Wednesdays

after_noon_delights = Delight.where("timestamp.hour" => { '$gte' => 12, '$lte' => 15 })
=> Only between 12pm and 3pm
```
See [search specs](https://github.com/sporkd/mongoid-metastamp/blob/master/spec/time_search_spec.rb)
for more complete examples.


Todo
======

* Add custom finders and scopes
* Auto migrate existing date/time fields
* Additional types


License
========

Copyright (c) 2011 Peter Gumeson.
See [LICENSE](https://github.com/sporkd/mongoid-metastamp/blob/master/LICENSE) for full license.

