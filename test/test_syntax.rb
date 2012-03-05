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

  test 'restrict and resume' do
    pipeline = each(%w(foo bar)) | restrict | each{ |x| x.chars} | resume
    result = []
    while v = pipeline.run
      result << v
    end
    assert_equal([{ 'foo' => %w(f o o)}, {'bar' => %w(b a r)}], result)
  end

  test 'wrap' do
    pipeline = each(%w(foo bar)) | wrap(each{ |x| x.chars}, :each)
    expected = %w(r a b o o f)
    while r = pipeline.run
      assert_equal(expected.pop, r)
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
end
