require 'helper'

class IgnoreFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf='')
    Fluent::Test::FilterTestDriver.new(Fluent::IgnoreFilter).configure(conf, true)
  end

  def test_configure_default
    d = create_driver
    assert_empty(d.instance.regexps)
    assert_empty(d.instance.excludes)
  end

  def test_configure
    d = create_driver(%[regexp1 level info])
    assert_equal({:key=>'level', :regexp=>/info/}, d.instance.regexps[0])
  end

  def test_emit
    d1 = create_driver(%[regexp1 level info])

    d1.run do
      d1.emit({'level'=>'info','ident'=>'kernel','server_name'=>'prod-web','message'=>'some info'})
      d1.emit({'level'=>'warn','ident'=>'kernel','server_name'=>'prod-web','message'=>'failed to do something'})
    end

    emits = d1.emits

    assert_equal(1, emits.length)
    assert_equal('warn', emits[0][2]['level'])
  end

  def test_emit_removebyident
    d1 = create_driver(%[regexp1 ident kernel])

    d1.run do
      d1.emit({'level'=>'info','ident'=>'kernel'})
      d1.emit({'level'=>'warn','ident'=>'kernel'})
    end

    emits = d1.emits

    assert_equal(0, emits.length)
  end

end
