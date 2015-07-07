# Fluent-plugin-ignore-filter

[Fluentd](http://fluentd.org) filter plugin to ignore messages.


## Installation

```bash
# for fluentd
$ gem install fluent-plugin-ignore-filter

# for td-agent2
$ sudo td-agent-gem install fluent-plugin-ignore-filter
```


## Usage

### Example 1:

```xml
<filter alert.messages.**>
  @type ignore
  regexp1 level info
</filter>
<filter alert.messages.**>
  @type ignore
  regexp1 server_name ^dev
</filter>
<filter alert.messages.**>
  @type ignore
  regexp1 level warning|warn
  regexp2 ident kernel
</filter>
```

Assuming following inputs are coming:

```
alert.messages: {"level":"info","ident":"kernel","server_name":"prod-web",message":"some info"}
alert.messages: {"level":"warn","ident":"kernel","server_name":"prod-web","message":"failed to do something"}
alert.messages: {"level":"error","ident":"kernel","server_name":"prod-web",message":"I/O error"}
alert.messages: {"level":"warn","ident":"chronyd","server_name":"prod-web","message":"System clock wrong"}
alert.messages: {"level":"error","ident":"sudo","server_name":"prod-web","message":"conversation failed"}
alert.messages: {"level":"error","ident":"sudo","server_name":"dev-web","message":"conversation failed"}
```

then output bocomes as belows:

```
alert.messages: {"level":"error","ident":"kernel","server_name":"prod-web",message":"I/O error"}
alert.messages: {"level":"warn","ident":"chronyd","server_name":"prod-web","message":"System clock wrong"}
alert.messages: {"level":"error","ident":"sudo","server_name":"prod-web","message":"conversation failed"}
```

### Example 2:

```xml
<filter alert.messages.**>
  @type ignore
  regexp1 level info|notice
  exclude1 ident crmd
</filter>
<filter alert.messages.**>
  @type ignore
  regexp1 level info|notice
  regexp2 ident crmd
  exclude1 message process_lrm_event
</filter>
```

Assuming following inputs are coming:

```
alert.messages: {"level":"info","ident":"kernel","server_name":"prod-web",message":"some info"}
alert.messages: {"level":"info","ident":"crmd","server_name":"prod-web","message":"process_lrm_event: Operation rundeck_monitor_0: not running"}
alert.messages: {"level":"info","ident":"crmd","server_name":"prod-web","message":"Performing"}
alert.messages: {"level":"warn","ident":"chronyd","server_name":"prod-web","message":"System clock wrong"}
```

then output bocomes as belows:

```
alert.messages: {"level":"info","ident":"crmd","server_name":"prod-web","message":"process_lrm_event: Operation rundeck_monitor_0: not running"}
alert.messages: {"level":"warn","ident":"chronyd","server_name":"prod-web","message":"System clock wrong"}
```


## Parameters
- regexp[1-20] *field\_key* *regexp*

    The target field key and the ignoring regular expression.

- exclude[1-20] *field_key* *regexp*

    The target field key and the excluding regular expression.


## TODO

* patches welcome!


## Contributing

1. Fork it ( https://github.com/bungoume/fluent-plugin-ignore-filter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Copyright

Copyright (c) 2015 Yuri Umezaki


## Thanks to
https://github.com/sonots/fluent-plugin-grep

## License

Apache License, Version 2.0
