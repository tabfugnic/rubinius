# -*- encoding: us-ascii -*-

require File.expand_path('../../../../../spec_helper', __FILE__)

describe :enumerator_lazy_to_enum, :shared => true do
  before(:each) do
    @infinite = (0..Float::INFINITY).lazy
  end

  it "requires multiple arguments" do
    enumerator_class::Lazy.instance_method(@method).arity.should < 0
  end

  it "returns a new instance of Enumerator::Lazy" do
    ret = @infinite.send @method
    ret.should be_an_instance_of(enumerator_class::Lazy)
    ret.should_not equal(@infinite)
  end

  it "sets nil to size when not given a block" do
    enumerator_class::Lazy.new(Object.new, 100) {}.send(@method).size.should == nil
  end

  it "sets given block to size when given a block" do
    enumerator_class::Lazy.new(Object.new, 100) {}.send(@method) { 30 }.size.should == 30
  end

  it "passes given arguments to wrapped method" do
    @infinite.send(@method, :each_slice, 2).map { |assoc| assoc.first * assoc.last }.first(4).should == [0, 6, 20, 42] 
  end

  it "used by some parent's methods though returning Lazy" do
    { :each_with_index => [],
      :with_index => [],
      :cycle => [1],
      :each_with_object => [Object.new],
      :with_object => [Object.new],
      :each_slice => [2],
      :each_entry => [],
      :each_cons => [2]
    }.each_pair do |method, args|
      @infinite.method(method).owner.should_not equal(enumerator_class::Lazy)
      @infinite.send(method, *args).should be_an_instance_of(enumerator_class::Lazy)
    end
  end
end
