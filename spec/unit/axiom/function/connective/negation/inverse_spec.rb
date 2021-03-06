# encoding: utf-8

require 'spec_helper'

describe Function::Connective::Negation, '#inverse' do
  subject { object.inverse }

  let(:attribute) { Attribute::Integer.new(:id)  }
  let(:operand)   { attribute.eq(1)              }
  let(:object)    { described_class.new(operand) }

  it_should_behave_like 'an idempotent method'

  it 'returns the operand' do
    should be(operand)
  end

  it 'is not invertible' do
    expect(subject.inverse).not_to eql(object)
  end
end
