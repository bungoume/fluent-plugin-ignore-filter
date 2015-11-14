require 'helper'

class IgnoreFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    type ignore
    regexp1 level warning|warn
    regexp2 ident kernel
  ]

  def create_driver(conf=CONFIG,tag='test')
    Fluent::Test::FilterTestDriver.new(Fluent::IgnoreFilter, tag).configure(conf)
  end

  def test_configure
    d = create_driver(CONFIG)
  end

  def test_emit
    d1 = create_driver(CONFIG)

    d1.run do
      d1.emit({"level"=>"info","ident"=>"kernel","server_name"=>"prod-web","message"=>"some info"})
    end
  end

end
