require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'proftpd': }

    	proftpd::user { 'example':
    		#Vm90YUp1bnRzUGVsU2kK
    		password => '$6$xkGStxTM$TyrthDmlYzXcVsOfNGS1bHUZvddVZImqxNXWGljw2rvijw3yeeA/N9eatMqou003uIb8k8kqWUtf7Ua24aqis0',
    		home => '/tmp/example',
        disable_ssh_user => false,
    	}

      file { '/tmp/example/test.list.ftp':
        ensure => 'present',
        content => "\nTestFTPls\n",
        require => Proftpd::User['example'],
      }

      file { '/tmp/test.upload.ftp':
        ensure => 'present',
        content => "\nTestFTPupload\n",
        require => Proftpd::User['example'],
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    it "sleep 10 to make sure proftpd is started" do
      expect(shell("sleep 10").exit_code).to be_zero
    end

    describe port(21) do
      it { should be_listening }
    end

    describe package($packagename) do
      it { is_expected.to be_installed }
    end

    describe service($servicename) do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

    describe file($proftpconf) do
      it { should be_file }
      its(:content) { should match 'puppet managed file' }
    end

    describe file('/etc/proftpd/modules.conf') do
      it { should be_file }
      its(:content) { should match 'puppet managed file' }
    end

    describe file('/etc/passwd') do
      it { should be_file }
      its(:content) { should match '^example:' }
    end

    describe file('/etc/shadow') do
      it { should be_file }
      its(:content) { should match '^example:' }
     end

    it "check ftp listing" do
      expect(shell("curl ftp://localhost/ --user example:Vm90YUp1bnRzUGVsU2kK -l 2>&1 | grep test.list.ftp").exit_code).to be_zero
    end

    it "check ftp uploading" do
      expect(shell("curl -T /tmp/test.upload.ftp ftp://localhost/ --user example:Vm90YUp1bnRzUGVsU2kK 2>&1").exit_code).to be_zero
    end

    it "check uploaded file" do
      expect(shell("cat /tmp/example/test.upload.ftp | grep TestFTPupload").exit_code).to be_zero
    end

    it "check ftp downloading" do
      expect(shell("curl ftp://localhost/test.list.ftp --user example:Vm90YUp1bnRzUGVsU2kK -o test.list.ftp 2>&1").exit_code).to be_zero
    end

    it "check downloaded file" do
      expect(shell("cat test.list.ftp | grep TestFTPls").exit_code).to be_zero
    end

  end

end
