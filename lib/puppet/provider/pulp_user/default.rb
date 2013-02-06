require 'base64'
require 'openssl'

Puppet::Type.type(:pulp_user).provide(:default) do
  desc "Provider for pulp user that talks to the Pulp v2 API"

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
    endpoint = "https://#{admin_user}:#{admin_pass}@localhost/pulp/api/v2/users/"
    endpoint
  end

  @@users_endpoint = parse_config 

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.instances
    users = JSON.parse(RestClient.get(@@users_endpoint))
    users.collect do |user|
      new(
        :name => user['login'],
        :description => user['name'],
        :roles => user['roles'],
        :ensure => :present
      )
    end
  end

  def self.prefetch(resources)
    users = instances
    resources.keys.each do |name|
      if provider = users.find{ |user| user.name == name }
        resources[name].provider = provider
      end
    end
  end

  def create
    req = { 
      'login'    => @resource[:name],
      'password' => @resource[:password],
      'name'     => @resource[:description],
    }
    RestClient.post(@@users_endpoint,JSON.dump(req))
    unless @resource[:roles].empty?
      user_endpoint = "#{@@users_endpoint}/#{resource[:name]}/"
      roles = {'delta' => {'roles'=> @resource[:roles]}}
      RestClient.put(user_endpoint,JSON.dump(roles))
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    user_endpoint = "#{@@users_endpoint}/#{resource[:name]}/"
    RestClient.delete(user_endpoint)
  end

  #Can't get password from instances
  def password
    user_endpoint = "#{@@users_endpoint}/#{resource[:name]}/"
    resp = RestClient.get(user_endpoint)
    pass = JSON.parse(resp.body)['password']
    if match_password(@resource['password'],pass)
      return @resource['password']
    else
      return pass
    end
  end

  def password=(should)
    @property_flush[:password] = should
  end

  def description
    @property_hash[:description]
  end

  def description=(should)
    @property_flush[:description] = should
  end

  def roles
    @property_hash[:roles]
  end

  def roles=(should)
    @property_flush[:roles] = should
  end

  def flush
    user_endpoint = "#{@@users_endpoint}/#{resource[:name]}/"
    unless @property_flush.empty?
      delta = {}
      (delta['password'] = @property_flush[:password]) if @property_flush[:password]
      (delta['roles'] = @property_flush[:roles]) if @property_flush[:roles]
      (delta['name'] = @property_flush[:description]) if @property_flush[:description]
      RestClient.put(user_endpoint,JSON.dump({'delta' => delta}))
    end
  end

  #Pulp uses some bastardized version of sha256_crypt
  def match_password(clear_text,hashed)
    iterations = 5000
    salt,hash = hashed.split(',').map!{|x| Base64.decode64(x)}
    result = clear_text
    sha256 = OpenSSL::Digest::SHA256.new
    for i in 1..iterations
      result = OpenSSL::HMAC.digest(sha256,result,salt)
    end
    result == hash
  end
end
