require 'helper'
include Stages

class TestStages < MiniTest::Unit::TestCase
  test 'evens' do
    evens = Evens.new
    result = (0..2).map{ evens.run }
    assert_equal([0, 2, 4], result)
  end

  test 'select' do
    pipeline = Evens.new | Select.new{ |val| val > 6}
    result = (0..2).map{ pipeline.run }
    assert_equal([8, 10, 12], result)
  end

  test 'map' do
    pipeline = Evens.new | Map.new{ |val| val * 3}
    result = (0..2).map{ pipeline.run }
    assert_equal([0, 6, 12], result)
  end

  test 'each_element' do
    pipeline = Each.new([1, 2, 3])
    result = (0..2).map{ pipeline.run }
    assert_equal([1, 2, 3], result)
  end

  test 'hash_lookup' do
    pipeline = Each.new([:do, :re, :mi]) | Map.new{ |x| sing[x]}
    result = (0..2).map { pipeline.run }
    assert_equal(['doe a deer a female deer', 'ray a drop of golden sun', 'me a name I call myself'], result)
  end

  test 'hash mode wrap' do
    pipeline = Each.new(%w(foo bar)) | Wrap.new(Each.new{ |x| x.chars})
    result = pipeline.run
    assert_equal(%w(f o o), result['foo'])
    result = pipeline.run
    assert_equal(%w(b a r), result['bar'])
  end

  test 'hash/aggregated wrap mode wrap' do
    pipeline = Each.new(%w(foo bar)) | Wrap.new(Each.new{ |x| x.chars} | Count.new, :aggregated)
    result = pipeline.run
    assert_equal(2, result['foo']['o'])
    result = pipeline.run
    assert_equal(3, result['bar'].keys.length)
  end

  test 'wrap/join array' do
    pipeline = Each.new(%w(foo bar)) | Wrap.new(Each.new{ |x| x.chars}) { |context, values| { context => values}}
    result = pipeline.run
    assert_equal({ 'foo' => %w(f o o)}, result)
  end

  test 'wrap/join each' do
    pipeline = Each.new(%w(foo bar)) | Wrap.new(Each.new{ |x| x.chars}, :each) { |context, values| { context => values}}
    result = pipeline.run
    assert_equal({ 'foo' => 'f'}, result)
    result = pipeline.run
    assert_equal({ 'foo' => 'o'}, result)
    result = pipeline.run
    assert_equal({ 'foo' => 'o'}, result)
    result = pipeline.run
    assert_equal({ 'bar' => 'b'}, result)
    result = pipeline.run
    assert_equal({ 'bar' => 'a'}, result)
    result = pipeline.run
    assert_equal({ 'bar' => 'r'}, result)
  end

  test 'array mode wrap' do
    pipeline = Each.new(%w(foo bar)) | Wrap.new(Each.new{ |x| x.chars}, :array)
    result = pipeline.run
    assert_equal(%w(f o o), result)
    result = pipeline.run
    assert_equal(%w(b a r), result)
  end

  test 'each mode wrap' do
    pipeline = Each.new(%w(foo bar)) | Wrap.new(Each.new{ |x| x.chars}, :each)
    expected = %w(r a b o o f)
    while !pipeline.done?
      assert_equal(expected.pop, pipeline.run)
    end
  end

  test 'feeder' do
    feeder = Feeder.new
    pipeline = feeder | Map.new{ |x| x*2}
    assert feeder.done?
    feeder << 1
    feeder << 2
    assert_equal(2, pipeline.run)
    assert_equal(4, pipeline.run)
    assert feeder.done?
    feeder << 3
    assert_equal(6, pipeline.run)
    assert pipeline.done?
  end

  test 'nil makes it through' do
    pipeline = Each.new([1, 2, nil, 4]) | Map.new{ |x| x.nil? ? x : x*2} | Exhaust.new
    result = pipeline.run
    assert_equal([2, 4, nil, 8], result)
  end

  test 'unique-jit' do
    order = []
    pipeline = Each.new('abcadefbega'){ |x| x.chars} |
      Map.new{ |x| order << 'a'; x} | Unique.new |
      Map.new{ |x| order << 'b'; x}
    results = []
    while !pipeline.done?
      results << pipeline.run
    end
    assert_equal(%w(a b c d e f g), results)
    assert_equal(%w(a b a b a b a a b a b a b a a a b a), order)
  end

  test 'unique-prefetch' do
    order = []
    pipeline = Each.new('abcadefbega'){ |x| x.chars} |
      Map.new{ |x| order << 'a'; x} | Unique.new(prefetch: true) |
      Map.new{ |x| order << 'b'; x}
    results = []
    while !pipeline.done?
      results << pipeline.run
    end
    assert_equal(%w(a b c d e f g), results)
    assert_equal(['a']*11 + ['b']*7, order)
  end

  test 'exhaust' do
    pipeline = Each.new(%w(foo bar zut)) | Exhaust.new
    assert_equal(%w(foo bar zut), pipeline.run)
  end

  test 'exhaust count' do
    pipeline = Each.new(%w(foo bar zut)) | ExhaustCount.new
    assert_equal(3, pipeline.run)
  end

  test 'cache' do
    order = []
    pipeline = Each.new([1, 3, 2, 3, 2, 1]) | Map.new{|x| order << 'a'; x} | Cache.new  | Map.new{|x| order << 'b'; x} | Exhaust.new
    assert_equal([1, 3, 2, 3, 2, 1], pipeline.run)
    assert_equal(%w(a a a a a a b b b b b b), order)
  end

  test 'count aggregates from prevous counts' do
    pipeline = Each.new([{ a: 2}, { a: 3}]) | Count.new
    assert_equal({ a: 5}, pipeline.run)
  end

  test 'count-recount doesnt choke on nils' do
    pipeline = Each.new([{ a: 2}, { a: nil}]) | Count.new
    assert_equal({ a: 2}, pipeline.run)
  end

  test 'trying to pull from nil returns nil, not an exception' do
    pipeline = Unique.new
    assert pipeline.done?
  end

  def sing
    { :do => 'doe a deer a female deer',
      :re => 'ray a drop of golden sun',
      :mi => 'me a name I call myself',
      :fa => 'far a long long way to run',
      :so => 'A needle pulling thread',
      :la => 'a note to follow so',
      :ti => 'a drink with jam and bread'}
  end
end
