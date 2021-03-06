# encoding: utf-8

require 'spec_helper'

describe Algebra::Join, '#each' do
  subject { object.each { |tuple| yields << tuple } }

  let(:object) { described_class.new(left, right)           }
  let(:left)   { Relation.new([[:id, Integer]], [[1], [2]]) }
  let(:yields) { []                                         }

  context 'when the attributes are joined' do
    let(:right) { Relation.new([[:id, Integer], [:name, String]], [[2, 'Dan Kubb']]) }

    it_should_behave_like 'an #each method'

    it 'yields only tuples' do
      subject
      yields.each { |tuple| expect(tuple).to be_instance_of(Tuple) }
    end

    it 'yields only tuples with the expected header' do
      subject
      yields.each { |tuple| expect(tuple.header).to be(object.header) }
    end

    it 'yields only tuples with the expected data' do
      expect { subject }.to change { yields.dup }
        .from([])
        .to([[2, 'Dan Kubb']])
    end
  end

  context 'when the attributes are disjoint' do
    let(:right) { Relation.new([[:name, String]], [['Dan Kubb']]) }

    it_should_behave_like 'an #each method'

    it 'yields only tuples' do
      subject
      yields.each { |tuple| expect(tuple).to be_instance_of(Tuple) }
    end

    it 'yields only tuples with the expected header' do
      subject
      yields.each { |tuple| expect(tuple.header).to be(object.header) }
    end

    it 'yields only tuples with the expected data' do
      expect { subject }.to change { yields.dup }
        .from([])
        .to([[1, 'Dan Kubb'], [2, 'Dan Kubb']])
    end
  end

  context 'when the attributes are an intersection' do
    let(:right) { Relation.new([[:id, Integer]], [[1]]) }

    it_should_behave_like 'an #each method'

    it 'yields only tuples' do
      subject
      yields.each { |tuple| expect(tuple).to be_instance_of(Tuple) }
    end

    it 'yields only tuples with the expected header' do
      subject
      yields.each { |tuple| expect(tuple.header).to be(object.header) }
    end

    it 'yields only tuples with the expected data' do
      expect { subject }.to change { yields.dup }
        .from([])
        .to([[1]])
    end
  end
end
