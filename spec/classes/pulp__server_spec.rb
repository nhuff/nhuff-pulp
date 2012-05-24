require 'spec_helper'

describe 'pulp::server' do
  context "Redhat" do
    let(:facts) {{:osfamily => 'RedHat',:fqdn => 'test.host.srv'}}

    it{should contain_package('pulp')}
    it{should contain_package('pulp-admin')}
    it{should contain_service('pulp-server')}
    it{should contain_exec('pulp-init')}
    it{should contain_file('/etc/pulp/pulp.conf').
      with_content(/server_name: test.host.srv/).
      with_content(/url: tcp:\/\/test.host.srv:5672/)
    }
    
  end

  context "RHEL" do
    let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat'}}

    it{should contain_yumrepo('pulp').
      with_baseurl(
        'http://repos.fedorapeople.org/repos/pulp/pulp/v1/stable/$releasever/$basearch/'
      )
    }
  end
  context "Fedora" do
    let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'Fedora'}}

    it{should contain_yumrepo('pulp').
      with_baseurl(
        'http://repos.fedorapeople.org/repos/pulp/pulp/v1/stable/fedora-$releasever/$basearch/'
      )
    }
  end
end
