# fluent-plugin-filter-record-map

Filter Plugin to create a new record containing the values converted by Ruby script.

[![Gem Version](https://badge.fury.io/rb/fluent-plugin-filter-record-map.svg)](http://badge.fury.io/rb/fluent-plugin-filter-record-map)
[![Build Status](https://travis-ci.org/winebarrel/fluent-plugin-filter-record-map.svg?branch=master)](https://travis-ci.org/winebarrel/fluent-plugin-filter-record-map)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-filter-record-map'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-filter-record-map

## Configuration

```apache
<filter>
  type record_map
  # map1: required
  map1 new_record["new_foo"] = record["foo"]
  map2 new_record["new_bar"] = record["bar"]
</filter>
```

## Usage

### Example1

```apache
<filter>
  type record_map
  map1 new_record["new_foo"] = record["foo"].upcase
  map2 new_record["new_bar"] = record["bar"].upcase
</filter>
```

```sh
$ echo '{"foo":"bar", "bar":"zoo"})' | fluentd test.data
#=> 2015-01-01 23:34:45 +0900 test.data: {"new_foo":"BAR","new_bar":"ZOO"}
```

### Example2

```apache
<filter>
  type record_map
  map1 record.each {|k, v| new_record[k] = k + "." + v }
</filter>
```

```sh
$ echo '{"foo":"bar", "bar":"zoo"}' | fluent-cat test.data
#=> 2015-01-01 23:34:45 +0900 test.data: {"foo":"foo.bar","bar":"bar.zoo"}
```

### Example3

```apache
<filter>
  type record_map
  map1 new_record = {"new_foo" => record["foo"]}
</filter>
```

```sh
$ echo '{"foo":"bar", "bar":"zoo"}' | fluent-cat test.data
#=> 2015-01-01 23:34:45 +0900 test.data: {"new_foo":"bar"}
```

### Use `tag`, `tag_parts`

```apache
<filter>
  type record_map
  map1 new_record["tag"] = tag
  map2 new_record["new_foo"] = tag_parts[1] + "." + record["foo"]
</filter>
```

```sh
$ echo '{"foo":"bar", "bar":"zoo"}' | fluent-cat test.data
#=> 2015-01-01 23:34:45 +0900 test.data: {"tag":"test.data","new_foo":"data.foo"}
```

### Use `hostname`

```apache
<filter>
  type record_map
  map1 new_record["hostname"] = hostname
</filter>
```

```sh
$ echo '{"foo":"bar", "bar":"zoo"}' | fluent-cat test.data
#=> 2015-01-01 23:34:45 +0900 test.data: {"hostname":"my-host"}
```
