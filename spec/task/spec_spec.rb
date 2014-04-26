#!/usr/bin/env rspec
require 'spec_helper'
require 'rake_context'

describe 'spec' do
  include_context 'rake'
  it 'creates the :spec task' do
    expect(Rake::Task.task_defined? :spec).to eq(true)
  end
end
