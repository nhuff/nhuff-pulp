Puppet::Type.type(:pulp_user).provide(:pulpadmin) do
  desc "Provider for pulp user using pulp-admin"

  commands :pa => 'pulp-admin'

  def create
    cmd_vec = []
    cmd_vec.concat(['-u',@resource[:pulp_user],'-p',@resource[:pulp_pass]])
    cmd_vec.concat(['user','create','--username',@resource[:name]])
    cmd_vec.concat(['--password',@resource[:password]])

    if @resource[:descr]
      cmd_vec.concat(['--name',@resource[:descr]])
    end
  
    pa(cmd_vec)
  end

  def destroy
    pa('-u',@resource[:pulp_user],'-p',@resource[:pulp_pass],'user',
      'delete','--username',@resource[:name])
  end

  def exists?
    pa('-u',@resource[:pulp_user],'-p',@resource[:pulp_pass],'user','list').
      match(/^Login\s*:\s+#{@resource[:name]}\s*$/)
  end

  def password
    #Unfortunatley can't really check password using pulp-admin so right now
    #we can only set on creation.  Just parrot back resource here.
    @resource[:password]
  end

  def password=(should)
    #This should never get called since password should always look in sync
    true
  end

  def descr
    users = pa('-u',@resource[:pulp_user],'-p',@resource[:pulp_pass],'user','list')
    users.match(/Login\s*:\s+#{@resource[:name]}\s*Name\s*:\s+([ \S]*\S)\s*$/m)
    $1
  end

  def descr=(should)
    pa('-u',@resource[:pulp_user],'-p',@resource[:pulp_pass],'user',
      'update', '--username',@resource[:name],'--name',should)
  end
end
