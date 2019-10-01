ip   = attribute('external_ip')
port = attribute('service_port')

control "nc" do
  title "Checking and Testing Remote Redis"

  describe command("(printf 'PING\\r\\n';) | nc #{ip} #{port}") do
    its("exit_status") { should eq 0 }
    its("stdout") { should match /\+PONG/ }
  end

end