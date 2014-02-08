fluent-plugin-boundio, a plugin for [Fluentd](http://fluentd.org)
=====================

## Overview
Fluentd Output plugin to make a call with boundio by KDDI. This Multilingual speech synthesis system uses VoiceText.

## Note
The release of KDDI, Boundio will be closed on the 30th Sep 2013.
http://news.boundio.jp/2013/03/22/boudio%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E6%96%B0%E8%A6%8F%E5%8F%97%E4%BB%98%E7%B5%82%E4%BA%86%E3%81%AE%E3%81%8A%E7%9F%A5%E3%82%89%E3%81%9B/

You can use twilio instead of boundio.  
https://github.com/y-ken/fluent-plugin-twilio

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

