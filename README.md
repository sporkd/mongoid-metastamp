Mongoid Metastamp
=========================

Provides Mongoid with enhanced meta-timestamps which allow querying by day, month, year, min, sec, or even by local vs. universal timezone.

What It Does
=========================
(Or why would I want to use this?)

Storing simple timestamps is all well and good if your queries are very simple.
But sometimes you might want to search for all events that occurred for a given range or across multiple locations and zones.

Well you could query for all possible events and then run a timezone conversion on each result in hopes of narrowing it down, but this is hard work.
Using mongoid-metastamp gives you a custom Time field does these conversions beforehand, and then stores the metadata in a MongoDB friendly way for easy querying.

Here are some basic examples:

* Find all employees that clocked in after 8:00 AM at either the Denver or San Diego location
* Find everyone who visited one of our nationwide stores on a Monday in January
* Find all transactions that occured on a weekday between 11 AM and 2 PM, across timezones


Installation
=========================

```
gem 'mongoid-metastamp'
```

```
$ bundle install
```

Usage
=========================

For the most part, metastamp Time fields can be used just like regular Time fields:

```ruby
class Party
  include Mongoid::Document
  field :starts_at, type: Mongoid::Metastamp::Time
  field :ends_at,   type: Mongoid::Metastamp::Time
end
```

```ruby
Party.create(starts_at: Time.now, ends_at: Time.now + 1.day)
party = Party.where(:starts_at.lt => Time.now, :ends_at.gt => Time.now).one
party.starts_at # => (sometime today)
party.ends_at   # => (sometime tomorrow)
```

Data Stored
=========================

When you define a metastamp field called `timestamp`, the following meta fields also get stored insides its hash:

```ruby
field :timestamp, type: Mongoid::Metastamp::Time
```

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

The `time` field stores whatever you set `timestamp` to.
It will also be the value retunred when you access `timestamp`.

You can access the raw metadata fields like this:

```ruby
event = Event.new(timestamp: "2011-10-05 10:00:00 -0700")
event['timestamp']['month']  # => October
event['timestamp']['day']    # => 5
event['timestamp']['year']   # => 2011
```

Querying
=========================

Because `time` is the default, it can be queried as `timestamp` or `timestamp.time`:

```ruby
good_old_times = Event.where(:timestamp.lt => 20.years.ago)
```

Or...

```ruby
good_old_times = Event.where("timestamp.time" => { '$lt' => 20.years.ago })
```

All the other fields need to be queried with the full syntax:

```ruby
hump_days = Day.where("timestamp.wday" => 5)

after_noon_delights = Delight.where("timestamp.hour" => { '$gt' => 12 })
```

(More to come)

