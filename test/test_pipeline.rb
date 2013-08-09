require 'helper'
include Stages

class TestPipeline < MiniTest::Unit::TestCase

  test 'simple basic pipeline' do
    evens = Evens.new
    mx3 = Select.new{ |x| x % 3 == 0}
    mx7 = Select.new{ |x| x % 7 == 0}
    mx3.source = evens
    mx7.source = mx3

    result = (0..2).map{ mx7.run }
    assert_equal([0, 42, 84], result)
  end

  test 'pipeline pipe syntax works' do
    pipeline = Evens.new | Select.new{ |x| x % 3 == 0} | Select.new{ |x| x % 7 == 0}
    result = (0..2).map{ pipeline.run }
    assert_equal([0, 42, 84], result)
  end

  test 'block stages work' do
    pipeline = Evens.new | Map.new{ |x| x * 3} | Select.new{ |x| x % 7 == 0}
    result = (0..2).map{ pipeline.run }
    assert_equal([0, 42, 84], result)
  end

  test 'exceptions do what you expect' do
    begin
      pipeline = Evens.new | Map.new{ |val| throw Exception.new "exception!" } | Select.new{ |v| v > 2}
      pipeline.run
      assert false
    rescue Exception => e
    end
  end

  test 'nil kills it' do
    pipeline = Each.new([1, 2, nil, 3])
    result = []
    while v = pipeline.run
      result << v
    end
    assert_equal([1, 2], result)
  end

  test 'complex substage hash example' do
    sub = Each.new{ |x| x.chars } | Map.new{ |x| x.to_sym} | Count.new
    pipeline = Each.new(%w(foo bar)) | Wrap.new(sub) | Map.new{ |x| { x.keys.first => x.values.first.first}}
    result = pipeline.run
    assert_equal({'foo' => { :f => 1, :o => 2}}, result)
    result = pipeline.run
    assert_equal({ 'bar' => { :b => 1, :a => 1, :r => 1}}, result)
  end

  test 'reset resets everything' do
    pipeline = Each.new([1, 2, 3])
    assert_equal(1, pipeline.run)
    pipeline.reset
    assert_equal(1, pipeline.run)
    assert_equal(2, pipeline.run)
  end

  test 'reset resets limit' do
    pipeline = Each.new([1, 2, 3, 4, 5]) | Limit.new(2)
    assert_equal(1, pipeline.run)
    assert_equal(2, pipeline.run)
    pipeline.reset
    assert_equal(1, pipeline.run)
    assert_equal(2, pipeline.run)
    assert_equal(:stages_eos, pipeline.run)
  end

  test 'nil stages are skipped/no-ops' do
    pipeline = Evens.new | nil | Select.new{ |x| x > 3}
    assert_equal(4, pipeline.run)
    assert_equal(6, pipeline.run)
  end

  test "pipeline as enum" do
    pipeline = Each.new([1,2,3,4,5]) | Select.new{ |x| x % 2 == 0}
    output = pipeline.map{ |x| x }
    assert_equal([2,4], output)

    pipeline.reset
    pipeline.each_slice(2) do |thing|
      assert_equal([2, 4], thing)
    end
  end
end
