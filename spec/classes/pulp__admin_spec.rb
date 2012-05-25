require 'spec_helper'

describe 'pulp::admin' do
  context 'RedHat' do
    let(:facts) {{:osfamily => 'RedHat'}}
    let(:params) {{:server => 'test.host.srv'}}

    it{should contain_package('pulp-admin')}
    it{should contain_file('/etc/pulp/admin/admin.conf').
      with_content(/host = test.host.srv/)
    }
    it{should contain_yumrepo('pulp')}
  end
end
