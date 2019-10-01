port = attribute('service_port')

control "redis" do
  title "Checking and Testing Redis"

  describe command("redis-cli") do
    it { should exist }
  end

  describe command("systemctl is-enabled redis-server") do
   its("exit_status") { should eq 0 }
  end

 describe service("redis-server") do
  it { should be_enabled }
  it { should be_running }
 end

 describe port "#{port}" do
  it { should be_listening }
 end


end