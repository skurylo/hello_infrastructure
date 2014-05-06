#!/usr/bin/env rspec
require 'spec_helper'
require 'rake_context'

describe 'ec2' do
  include_context 'rake'
  describe 'clean' do
    it 'is a task' do
      expect(Rake::Task.task_defined? :'ec2:clean').to eq(true)
    end
    it 'should call EC2.clean' do
      ec2 = double()
      ec2.should_receive(:clean).once
      EC2.should_receive(:new).and_return(ec2)
      Rake::Task[:'ec2:clean'].invoke
    end
  end
end

