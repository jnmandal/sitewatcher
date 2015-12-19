# filewatcher
require 'open-uri'
require 'fileutils'
require 'yaml'
# alert
require 'net/http'
require 'json'


# important data
secrets = YAML.load_file(File.expand_path('../secrets.yml', __FILE__))
TARGET  = secrets['target']
SLACK   = secrets['slack_webhook']

# unsuspicious headers
HEADERS = {
  'Referer' => 'https://www.google.com/',
  'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36'
}

# the method to send an alert to slack
def alert!
  message = "ALERT: The page at #{TARGET} has changed."
  puts message
  uri = URI.parse(SLACK)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  response = http.post(uri.path, {text: message}.to_json, {"Content-Type" => "application/json","Accept" => "application/json"})
end

# basic logic to watch page
begin
  request = open(TARGET, HEADERS)
rescue OpenURI::HTTPError => error
  response = error.io
  puts response.status
end

new_site = File.open(File.expand_path('../site.html', __FILE__), 'w')
new_site << request.read
new_site.close

if File.exist?(File.expand_path('../site.old.html', __FILE__))
  files_same = FileUtils.compare_file(File.expand_path('../site.html', __FILE__), File.expand_path('../site.old.html', __FILE__))
  alert! unless files_same
  File.delete(File.expand_path('../site.old.html', __FILE__))
end

File.rename(File.expand_path('../site.html', __FILE__), File.expand_path('../site.old.html', __FILE__))
