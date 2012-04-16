require 'helper'
include Stages

class TestSyntax < MiniTest::Unit::TestCase
  include Stages::Sugar

  test 'select and map' do
    pipeline = evens | select{ |val| val > 6} | map{ |val| val * 2}
    assert_equal(16, pipeline.run)
  end

  test 'each and group' do
    pipeline = each([1, 2, 3]) | map{ |x| [1]*x} | each | group
    assert_equal({ 1 => 6}, pipeline.run)
  end

  test 'wrap' do
    pipeline = each(%w(foo bar)) | wrap(each{ |x| x.chars}, :each)
    expected = %w(r a b o o f)
    while !pipeline.done?
      assert_equal(expected.pop, pipeline.run)
    end
  end

  test 'unique and exhaust' do
    pipeline = each([1, 3, 2, 3, 2, 1]) | unique | run_until_exhausted
    assert_equal([1, 3, 2], pipeline.run)
  end

  test 'exhaustcount' do
    pipeline = each([1, 3, 2, 3, 2, 1]) | unique | exhaust_and_count
    assert_equal(3, pipeline.run)
  end

  test 'cache' do
    order = []
    pipeline = each([1, 3, 2, 3, 2, 1]) | map{|x| order << 'a'; x} | cache  | map{|x| order << 'b'; x} | run_until_exhausted
    assert_equal([1, 3, 2, 3, 2, 1], pipeline.run)
    assert_equal(%w(a a a a a a b b b b b b), order)
  end

  test 'feeder' do
    f = feeder
    pipeline = f | map{ |x| x*2}
    assert feeder.done?
    f << 1
    f << 2
    assert_equal(2, pipeline.run)
    assert_equal(4, pipeline.run)
    assert f.done?
    f << 3
    assert_equal(6, pipeline.run)
    assert pipeline.done?
  end
end
