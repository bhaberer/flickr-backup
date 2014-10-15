module FlickrConfig
  def self.setup_flickr(cred_file = 'config.yml')
    creds = YAML.load_file(cred_file)
    [:api_key, :shared_secret, :access_token, :access_secret].each do |k|
      fail "Config missing #{k}!" unless creds.key?(k)
    end

    FlickRaw.api_key = creds[:api_key]
    FlickRaw.shared_secret = creds[:shared_secret]
    flickr.access_token = creds[:access_token]
    flickr.access_secret = creds[:access_secret]
    flickr
  end

  def self.credential_check(flickr)
    login = flickr.test.login
    puts "You are now authenticated as #{login.username}"
    true
  rescue FlickRaw::FailedResponse => e
    puts "Authentication failed : #{e.msg}"
    false
  end
end
