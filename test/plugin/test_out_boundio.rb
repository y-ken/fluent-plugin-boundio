require 'helper'

class BoundioOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    user_serial_id  BOUNDIO_USER_SERIAL_ID
    api_key         BOUNDIO_API_KEY
    user_key        BOUNDIO_USER_KEY
    default_number  09012345678
  ]

  def create_driver(conf=CONFIG,tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::BoundioOutput, tag).configure(conf)
  end

  def test_configure
    assert_raise(Fluent::ConfigError) {
      d = create_driver('')
    }
    d = create_driver %[
      user_serial_id  BOUNDIO_USER_SERIAL_ID
      api_key         BOUNDIO_API_KEY
      user_key        BOUNDIO_USER_KEY
      default_number  09012345678
    ]
    d.instance.inspect
    assert_equal 'BOUNDIO_USER_SERIAL_ID', d.instance.user_serial_id
    assert_equal 'BOUNDIO_API_KEY', d.instance.api_key
    assert_equal 'BOUNDIO_USER_KEY', d.instance.user_key
    assert_equal '09012345678', d.instance.default_number
  end

  def test_emit
    d1 = create_driver(CONFIG, 'input.access')
    time = Time.parse("2012-01-02 13:14:15").to_i
    d1.run do
      d1.emit({'message' => 'sample message'})
    end
    emits = d1.emits
    assert_equal 0, emits.length
  end
end

