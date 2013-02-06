Puppet::Type.newtype(:pulp_repo) do
  @doc = "Manage a repo definition on a pulp server"

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:name) do
    desc "The id of the repository"
    validate do |value|
      unless value =~ /^\S+/
        raise ArgumentError, "Repository id must not contain spaces"
      end
    end
  end

  newparam(:pulp_user) do
    desc "Username to auth to pulp server as"
  end

  newparam(:pulp_pass) do
    desc "Password to use for auth with pulp server"
  end
  
  newproperty(:descr) do
    desc "The display name of the repository"
  end

  newproperty(:feed) do
    desc "Set the feed to pull from"
  end

  autorequire(:service) do
    ['pulp-server']
  end
end
