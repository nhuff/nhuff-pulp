require 'spec_helper'

describe 'pulp::consumer' do
  context "RedHat" do
    let(:facts) {{:osfamily => 'RedHat'}}
    let(:params) {{:server => 'test.host.srv'}}

    it{should contain_package('pulp-consumer')}
    it{should contain_file('/etc/pulp/consumer/consumer.conf').
      with_content(/host = test.host.srv/)
    }
    it{should contain_service('pulp-agent')}
    it{should contain_yumrepo('pulp')}
  end
end
