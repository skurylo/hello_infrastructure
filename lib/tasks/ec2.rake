require 'amazon'
namespace :ec2 do
  desc 'Terminate all EC2 resources'
  task :clean do
    ec2 = EC2.new
    ec2.clean
  end
end
