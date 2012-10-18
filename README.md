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

### Sample
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

## Use Case
It is a example to make a call when it goes to over 5 times 500_errors in a minutes.

### Environment

#### Apache LogFormat (httpd.conf)
LogFormat "%V %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %D" combined

#### Target Website
www.example.com

### Sample
`````
# following an access_log
<source>
  type tail
  path /var/log/httpd/access_log
  format /^(?<domain>[^ ]*) (?<host>[^ ]*) [^ ]* (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^ ]*) +\S*)?" (?<status>[^ ]*) (?<size>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)" (?<response_time>[^ ]*))?$/
  time_format %d/%b/%Y:%H:%M:%S %z
  tag td.apache.access
  pos_file /var/log/td-agent/apache_access.pos
</source>

# extract the target domain and rewrite tag name to site.ExampleWebSite
<match td.apache.access>
  type rewrite_tag_filter
  rewriterule1 domain ^www.example.com$ site.ExampleWebSite
</match>

# count values of "status" by each pattern
<match site.ExampleWebSite>
  type copy
  <store>
    type stdout
    # Record Sample
    # site.ExampleWebSite: {"domain":"www.example.com","host":"127.0.0.1","user":"-","method":"GET","path":"/home","status":"200","size":"12121","referer":"-","agent":"Wget","response_time":"0"}
  </store>
  <store>
    type      datacounter
    unit      minute
    count_key status
    tag       count.responsecode.ExampleWebSite
    aggregate all
    pattern1  200 ^200$
    pattern2  2xx ^2\d\d$
    pattern3  301 ^301$
    pattern4  302 ^302$
    pattern5  3xx ^3\d\d$
    pattern6  403 ^403$
    pattern7  404 ^404$
    pattern8  410 ^410$
    pattern9  4xx ^4\d\d$
    pattern10 500 ^5\d\d$
    outcast_unmatched false
  </store>
</match>

# output a record when the "status_500" value exceed threshold.
<match count.responsecode.ExampleWebSite>
  type copy
  <store>
    type stdout
    # Record Sample
    # count.responsecode.ExampleWebSite: {"unmatched_count":0,"unmatched_rate":0.0,"unmatched_percentage":0.0,"200_count":0,"200_rate":0.0,"200_percentage":0.0,"2xx_count":0,"2xx_rate":0.0,"2xx_percentage":0.0,"301_count":0,"301_rate":0.0,"301_percentage":0.0,"302_count":0,"302_rate":0.0,"302_percentage":0.0,"3xx_count":0,"3xx_rate":0.0,"3xx_percentage":0.0,"403_count":0,"403_rate":0.0,"403_percentage":0.0,"404_count":0,"404_rate":0.0,"404_percentage":0.0,"410_count":0,"410_rate":0.0,"410_percentage":0.0,"4xx_count":0,"4xx_rate":0.0,"4xx_percentage":0.0,"500_count":20,"500_rate":0.33,"500_percentage":100.0}
  </store>
  <store>
    type notifier
    input_tag_remove_prefix count.responsecode
    <def>
      pattern            status_500
      check              numeric_upward
      warn_threshold     5
      crit_threshold     20
      tag                alert.http_500_error
      target_key_pattern ^500_count$
    </def>
  </store>
</match>

# build an alert message
<match alert.http_500_error>
  type copy
  <store>
    type stdout
    # Record Sample
    # alert.http_500_error: {"pattern":"status_500","target_tag":"ExampleWebSite","target_key":"500_count","check_type":"numeric_upward","level":"crit","threshold":20.0,"value":20.0,"message_time":"2012-10-18 20:08:52 +0900"}
  </store>
  <store>
    type             deparser
    tag              notify.call
    # format         WebSite has down level %s. The service of %s %s is exceed %s times. This threshold is %s now. Thank you.
    format           サイトが落ちました。レベルは%s。%sの%sが%s回を超えました。しきい値は%sです。対応お願いします。
    format_key_names level,target_tag,target_key,value,threshold
    key_name         message
    reserve_data     no
  </store>
</match>

# make a call to 09012345678
<match notify.call>
  type copy
  <store>
    type stdout
  </store>
    type boundio
    user_serial_id  YOUR_BOUNDIO_USER_SERIAL_ID
    api_key         YOUR_BOUNDIO_API_KEY
    user_key        YOUR_BOUNDIO_USER_KEY
    default_number  09012345678
    developer_tool  yes
  </store>
</match>
`````

## Backend Service
You can register to get 20 times trial call credit.
http://boundio.jp/

## TODO
patches welcome!

## Copyright
Copyright © 2012- Kentaro Yoshida (@yoshi_ken)

## License
Apache License, Version 2.0
