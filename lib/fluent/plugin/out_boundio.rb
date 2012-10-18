# -*- coding: utf-8 -*-
class Fluent::BoundioOutput < Fluent::Output
  Fluent::Plugin.register_output('boundio', self)

  config_param :user_serial_id, :string
  config_param :user_key, :string, :default => nil # Optional at this time
  config_param :api_key, :string
  config_param :default_number, :string
  config_param :developer_tool, :string, :default => 'no'

  def initialize
    super
    require 'uri'
    require 'net/https'
  end

  def configure(conf)
    super
    @voice_type = 1
    @developer_tool = Fluent::Config.bool_value(@developer_tool) || false
    $log.info "boundio using developer tool api" if @developer_tool
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
      path = @developer_tool ? '/api/vd2/' : '/api/v2/'
      response = https.post(path + @user_serial_id + '/call', URI.escape(query))
      $log.info "boundio makeing a call: #{message} "
      $log.info "boundio call result: #{response.body}"
    rescue => e
      $log.error("boundio Error: #{e.message}")
    end
  end
end

