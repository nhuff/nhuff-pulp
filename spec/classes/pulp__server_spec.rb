require 'spec_helper'

describe 'pulp::server' do
  context "Redhat" do
    let(:facts) {{:osfamily => 'RedHat',:fqdn => 'test.host.srv'}}

    it{should contain_package('pulp')}
    it{should contain_service('pulp-server')}
    it{should contain_exec('pulp-init')}
    it{should contain_file('/etc/pulp/pulp.conf').
      with_content(/server_name: test.host.srv/).
      with_content(/url: tcp:\/\/test.host.srv:5672/)
    }
    it{should contain_yumrepo('pulp')}
  end
end
