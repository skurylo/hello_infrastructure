#!/usr/bin/env rspec
require 'spec_helper'
require 'rake_context'

describe 'hello' do
  include_context 'rake'
  it 'should print hello' do
    Hello.should_receive(:puts)
    Rake::Task[:hello].invoke
  end
end
