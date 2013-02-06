Puppet::Type.newtype(:pulp_role) do
  @doc = "Manage a pulp role"

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
    desc "The id of the role"
    validate do |value|
      unless value =~ /^\S+/
        raise ArgumentError, "User id must not contain spaces"
      end
    end
  end

  newproperty(:display_name) do
    defaultto " "
    desc "Display name for the role"
  end
  
  newproperty(:description) do
    defaultto " "
    desc "Description of the role"
  end
end
