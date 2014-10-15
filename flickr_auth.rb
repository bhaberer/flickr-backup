require 'launchy'
require 'flickraw'
require 'yaml'

creds = YAML.load_file('config.yml')
[:api_key, :shared_secret].each do |k|
  fail "Config.yml missing #{k}!" unless creds.key?(k)
end

FlickRaw.api_key = creds[:api_key]
FlickRaw.shared_secret = creds[:shared_secret]

token = flickr.get_request_token
auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'read')

puts "Open this url in your process to complete the authication process : #{auth_url}"
Launchy.open(auth_url)
puts "Copy here the number given when you complete the process."
verify = gets.strip

begin
  flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
  login = flickr.test.login
  puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
  File.open('config.yml', 'w') do |file|
    YAML.dump({ api_key: creds[:api_key],
                shared_secret: creds[:shared_secret],
                access_token: flickr.access_token,
                access_secret: flickr.access_secret }, file)
  end
rescue FlickRaw::FailedResponse => e
  puts "Authentication failed : #{e.msg}"
end
