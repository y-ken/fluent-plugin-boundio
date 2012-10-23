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

## Configuration

### Message Format
`````
fluent_logger.post('notify.call', {
  :message  => 'Hello World!',   # Required
  :number   => '090-1234-5678',  # Optional
  :voice    => 'male'            # Optional
})
`````

### Sample
`````
<source>
  type http
  port 8888
</source>

<match notify.call>
  type boundio
  user_serial_id  BOUNDIO_USER_SERIAL_ID  # Required
  api_key         BOUNDIO_API_KEY         # Required
  user_key        BOUNDIO_USER_KEY        # Required
  default_number  090-1234-5678           # Optional
  default_voice   female                  # Optional [female/male] (default: female)
  # http://boundio.jp/docs/%E3%83%87%E3%83%99%E3%83%AD%E3%83%83%E3%83%91%E3%83%BC%E3%83%84%E3%83%BC%E3%83%AB
  developer_tool  yes
</match>
`````

### Quick Test
`````
# test call to 09012345678 and say "Help! System ABC has down." with male voice.
$ curl http://localhost:8888/notify.call -F 'json={"number":"09012345678","voice":"male","message":"Help! System ABC has down."}'

# check boundio activity log
$ tail -f /var/log/td-agent/td-agent.log
`````

## Reference

### Use Case1: make a call when it goes to over 5 times 500_errors in a minutes.
http://github.com/y-ken/fluent-plugin-boundio/blob/master/example.conf

## Backend Service
You can register to get 20 times trial call credit.
http://boundio.jp/

## TODO
patches welcome!

## Copyright
Copyright © 2012- Kentaro Yoshida (@yoshi_ken)

## License
Apache License, Version 2.0

