require 'helper'

class IgnoreFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf='')
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::IgnoreFilter).configure(conf)
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

    d1.run(default_tag: 'test') do
      d1.feed({'level'=>'info','ident'=>'kernel','server_name'=>'prod-web','message'=>'some info'})
      d1.feed({'level'=>'warn','ident'=>'kernel','server_name'=>'prod-web','message'=>'failed to do something'})
    end

    filtered = d1.filtered

    assert_equal(1, filtered.length)
    assert_equal('warn', filtered[0][1]['level'])
  end

  def test_emit_removebyident
    d1 = create_driver(%[regexp1 ident kernel])

    d1.run(default_tag: 'test') do
      d1.feed({'level'=>'info','ident'=>'kernel'})
      d1.feed({'level'=>'warn','ident'=>'kernel'})
    end

    filtered = d1.filtered

    assert_equal(0, filtered.length)
  end

end
