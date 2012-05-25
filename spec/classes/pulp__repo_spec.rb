require 'spec_helper'

describe 'pulp::repo' do
    context "RHEL" do
    let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat'}}

    it{should contain_yumrepo('pulp').
      with_baseurl(
        'http://repos.fedorapeople.org/repos/pulp/pulp/v1/stable/$releasever/$basearch/'
      )
    }
  end
    context "CentOS" do
    let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'CentOS'}}

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
