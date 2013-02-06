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
    desc "Password for user"
  end

  newproperty(:description) do
    desc "Display name of user"
  end

  newproperty(:roles, :array_matching => :all) do
    defaultto []
    desc "Roles this user should be in"
  end

  newparam(:pulp_user) do
    desc "Username to auth to pulp server as"
  end

  newparam(:pulp_pass) do
    desc "Password to use for auth with pulp server"
  end

  autorequire(:pulp_role) do
    self[:roles]
  end
end 
