require 'yaml'

Puppet::Type.type(:pulp_repo).provide(:pulpadmin) do
  desc "Provider for pulp repo using pulp-admin"

  commands :pa  => 'pulp-admin'

  def create
    cmd_vec = []
    cmd_vec.concat(['-u',@resource[:pulp_user],'-p',@resource[:pulp_pass]]) 
    cmd_vec.concat(['repo','create','--id',@resource[:name]]) 

    if @resource[:descr]
      cmd_vec << '--name' << @resource[:descr]
    end
    if @resource[:feed]
      cmd_vec << '--feed' << @resource[:feed]
    end

    pa(cmd_vec)

  end

  def destroy
    pa('-u',@resource[:pulp_user],'-p',@resource[:pulp_pass],'repo','delete','--id',@resource[:name])
  end

  def exists?
    pa('-u',@resource[:pulp_user],'-p',@resource[:pulp_pass],'repo','list').match(/^Id\s+#{@resource[:name]}\s*$/)
  end

  def descr
    dr_match = Regexp.new(/^Name\s+(\S.*)$/)
    dr_match.match(pa('-u',@resource[:pulp_user],'-p',@resource[:pulp_pass],'repo','info','--id',@resource[:name]))[1].rstrip()
  end

  def descr=(should)
    pa('-u',@resource[:pulp_user],'-p',@resource[:pulp_pass],'repo','update','--id',@resource[:name],'--name',should)
  end

  def feed
    fd_match = Regexp.new(/^Feed URL\s+(\S.*)$/)
    fd_match.match(pa('-u',@resource[:pulp_user],'-p',@resource[:pulp_pass],'repo','info','--id',@resource[:name]))[1].rstrip()
  end

  def feed=(should)
    pa('-u',@resource[:pulp_user],'-p',@resource[:pulp_pass],'repo','update','--id',@resource[:name],'--feed',should)
  end

end
