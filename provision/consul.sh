cd /tmp/
[ -x /usr/local/bin/consul ] && exit 0
if [ -r /vagrant/target/0.2.0_linux_amd64.zip ]; then
  unzip /vagrant/target/0.2.0_linux_amd64.zip
else
  wget https://dl.bintray.com/mitchellh/consul/0.2.0_linux_amd64.zip
  unzip consul.zip
fi
chmod +x consul
mv consul /usr/local/bin/consul
