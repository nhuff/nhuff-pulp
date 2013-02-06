Puppet::Type.type(:pulp_role).provide(:default) do
  desc "Provider for pulp roles that talks to the Pulp v2 API"

  confine :true => 
  begin
    require 'json'
    require 'rest-client'
  rescue LoadError
    false
  else
    true
  end

  def self.parse_config
    file = "#{Facter['puppet_vardir'].value}/pulp.json"
    json = File.open(file).read
    config = JSON.parse(json)
    admin_user = config['user']
    admin_pass = config['pass']
    endpoint = "https://#{admin_user}:#{admin_pass}@localhost/pulp/api/v2/roles/"
    endpoint
  end

  @@roles_endpoint = parse_config 

  def self.instances
    roles = JSON.parse(RestClient.get(@@roles_endpoint))
    roles.collect do |role|
      new(
        :name         => role['id'],
        :description  => role['description'],
        :display_name => role['display_name'],
        :ensure       => :present
      )
      end
  end

  def self.prefetch(resources) 
    roles = instances
    resources.keys.each do |name|
      if provider = roles.find{ |role| role.name == name }
        resources[name].provider = provider
      end
    end
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    req = {
      'role_id'      => @resource[:name],
      'description'  => @resource[:description],
      'display_name' => @resource[:display_name]
    }   
    RestClient.post(@@roles_endpoint,JSON.dump(req))
  end

  def destroy
    role_endpoint = "#{@@roles_endpoint}/#{@resource[:name]}/"
    RestClient.delete(role_endpoint)
  end

  def display_name
    @property_hash[:display_name]
  end

  def display_name=(should)
    @property_flush[:display_name] = should
  end

  def description
    @property_hash[:description]
  end

  def description=(should)
    @property_flush[:description] = should
  end

  def flush
    role_endpoint = "#{@@roles_endpoint}/#{@resource[:name]}/"
    unless @property_flush.empty?
      puts @property_flush
      req = {}
      (req['description']  = @property_flush[:description]) if @property_flush[:description]
      (req['display_name'] = @property_flush[:display_name]) if @property_flush[:display_name]
      RestClient.put(role_endpoint,JSON.dump({'delta' => req}))
    end
  end

end

