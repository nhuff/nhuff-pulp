Puppet::Type.newtype(:pulp_user) do
  @doc = "Manage a pulp user"

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
    desc "The id of the user"
    validate do |value|
      unless value =~ /^\S+/
        raise ArgumentError, "User id must not contain spaces"
      end
    end
  end

  newproperty(:password) do
    desc "Initial password for user"
  end

  newproperty(:descr) do
    desc "Display name of user"
  end

  newparam(:pulp_user) do
    desc "Username to auth to pulp server as"
  end

  newparam(:pulp_pass) do
    desc "Password to use for auth with pulp server"
  end

  autorequire(:service) do
    ['pulp-server']
  end
end 
