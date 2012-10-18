fluent-plugin-boundio
=====================

## Component
Fluentd Output plugin to make a call with boundio by KDDI. This Multilingual speech synthesis system uses VoiceText.

## Installation

### native gem
`````
gem install fluent-plugin-boundio
`````

### td-agent gem
`````
/usr/lib64/fluent/ruby/bin/fluent-gem install fluent-plugin-boundio
`````

## Output Configuration

### Output Sample
`````
<source>
  type http
  port 8888
</source>

<match notify.call>
  type boundio
  user_serial_id  YOUR_BOUNDIO_USER_SERIAL_ID
  api_key         YOUR_BOUNDIO_API_KEY
  user_key        YOUR_BOUNDIO_USER_KEY
  default_number  09012345678
  # http://boundio.jp/docs/%E3%83%87%E3%83%99%E3%83%AD%E3%83%83%E3%83%91%E3%83%BC%E3%83%84%E3%83%BC%E3%83%AB
  developer_tool  yes
</match>
`````

### Debug
`````
$ curl http://localhost:8888/notify.call -F 'json={"number":"09012345678","message":"Help! System ABC has down."}'
$ tail -f /var/log/td-agent/td-agent.log
`````

## Backend Service
http://boundio.jp/

## TODO
patches welcome!

## Copyright
Copyright © 2012- Kentaro Yoshida (@yoshi_ken)

## License
Apache License, Version 2.0
