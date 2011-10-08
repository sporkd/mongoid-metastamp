Mongoid Metastamp
=========================

This gem provides Mongoid with enhanced meta-timestamps which allow querying by day, month, year, min, sec, or even by local vs. universal timezone.

What It Does
=========================
(Or why would I want to use this?)

Storing simple timestamps is all well and good if you only need to search inside a continuous range relative to one timezone.
Sometimes however, you might want to search for all events that occurred between 9 AM and 5 PM, but across multiple locations and timezones.

So you could query all possible events between some range and then run a conversion on each result to narrow it down, but that makes servers die and developers cry.
With mongoid-metastamp you get a custom timestamp field that performs conversions when you save, and then stores the metadata in a MongoDB friendly way for easy querying.

Storage
=========================
(What metadata should we store?)

* time_in_zone (Date)
* time_normalized (Date)
* year (Int)
* month (Int)
* day (Int)
* hour (Int)
* min (Int)
* sec (Int)
* time_zone (String)


(More to come)