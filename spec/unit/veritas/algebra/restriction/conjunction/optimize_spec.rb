require File.expand_path('../../../../../../spec_helper', __FILE__)

describe 'Veritas::Algebra::Restriction::Conjunction#optimize' do
  before do
    @attribute = Attribute::Integer.new(:id)
  end

  subject { @conjunction.optimize }

  describe 'left and right are predicates' do
    before do
      @left  = @attribute.gt(1)
      @right = @attribute.lt(3)

      @conjunction = Algebra::Restriction::Conjunction.new(@left, @right)
    end

    it { should equal(@conjunction) }
  end

  describe 'left and right are negated predicates' do
    before do
      @conjunction = Algebra::Restriction::Conjunction.new(
        Algebra::Restriction::Negation.new(@attribute.gt(1)),
        Algebra::Restriction::Negation.new(@attribute.lt(3))
      )
    end

    it { should_not equal(@conjunction) }

    it 'should invert the operands' do
      should eql(Algebra::Restriction::Conjunction.new(@attribute.lte(1), @attribute.gte(3)))
    end
  end

  describe 'left and right are the same' do
    before do
      @left  = @attribute.gt(1)
      @right = @attribute.gt(1)

      @conjunction = Algebra::Restriction::Conjunction.new(@left, @right)
    end

    it { should eql(@left) }
  end

  describe 'left and right are true propositions' do
    before do
      @left  = Veritas::Algebra::Restriction::True.instance
      @right = Veritas::Algebra::Restriction::True.instance

      @conjunction = Algebra::Restriction::Conjunction.new(@left, @right)
    end

    it { should be_instance_of(Veritas::Algebra::Restriction::True) }
  end

  describe 'left and right are false propositions' do
    before do
      @left  = Veritas::Algebra::Restriction::False.instance
      @right = Veritas::Algebra::Restriction::False.instance

      @conjunction = Algebra::Restriction::Conjunction.new(@left, @right)
    end

    it { should be_instance_of(Veritas::Algebra::Restriction::False) }
  end

  describe 'right is a true proposition' do
    before do
      @left  = @attribute.gt(1)
      @right = Veritas::Algebra::Restriction::True.instance

      @conjunction = Algebra::Restriction::Conjunction.new(@left, @right)
    end

    it { should equal(@left) }
  end

  describe 'left is a true proposition' do
    before do
      @left  = Veritas::Algebra::Restriction::True.instance
      @right = @attribute.lt(3)

      @conjunction = Algebra::Restriction::Conjunction.new(@left, @right)
    end

    it { should equal(@right) }
  end

  describe 'right is a false proposition' do
    before do
      @left  = @attribute.gt(1)
      @right = Veritas::Algebra::Restriction::False.instance

      @conjunction = Algebra::Restriction::Conjunction.new(@left, @right)
    end

    it { should be_instance_of(Veritas::Algebra::Restriction::False) }
  end

  describe 'left is a false proposition' do
    before do
      @left  = Veritas::Algebra::Restriction::False.instance
      @right = @attribute.lt(3)

      @conjunction = Algebra::Restriction::Conjunction.new(@left, @right)
    end

    it { should be_instance_of(Veritas::Algebra::Restriction::False) }
  end
end