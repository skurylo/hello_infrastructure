desc "Fetch the consul binary into the target directory"
task :consul => 'target/consul'

file 'target/consul' => 'target' do
  f ='0.2.0_linux_amd64.zip'
  sh "curl -L https://dl.bintray.com/mitchellh/consul/#{f} -o target/#{f}"
  sh "unzip target/#{f} -d target/"
  sh "chmod +x target/consul"
end

directory 'target'
