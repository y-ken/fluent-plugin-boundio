# -*- coding: utf-8 -*-
class Fluent::BoundioOutput < Fluent::Output
  Fluent::Plugin.register_output('boundio', self)

  config_param :user_serial_id, :string
  config_param :api_key, :string
  config_param :user_key, :string
  config_param :default_number, :string

  def initialize
    super

    require 'uri'
    require 'net/https'
  end

  def configure(conf)
    super

    @voice_type = 1
  end

  def emit(tag, es, chain)
    es.each do |time,record|
      number = record['number'].nil? ? @default_number : record['number']
      call(number, record['message'])
    end

    chain.next
  end

  def call(number, message)
    begin
      https = Net::HTTP.new('boundio.jp', 443)
      https.use_ssl = true
      cast = "file_d(#{message}, #{@voice_type})"
      query = 'key=' + @api_key + '&tel_to=' + number + '&cast=' + cast
      response = https.post('/api/vd2/' + @user_serial_id + '/call', URI.escape(query))
      $log.info "boundio makeing a call: #{message} "
      $log.info "boundio call result: #{response.body}"
    rescue => e
      $log.error("Boundio Error: #{e.message}")
    end
  end
end

