require 'json'
require 'net/https'

report_dir = ARGV[0]

def submit_to_splunk (report)
  splunk_server = 'splunk.c.splunk-217321.internal'
  splunk_token  = '1b22a802-775e-45d6-bb94-6528f363721a'
  splunk_port = '8088'

  request = Net::HTTP::Post.new("https://#{splunk_server}:#{splunk_port}/services/collector")
  request.add_field("Authorization", "Splunk #{splunk_token}")
  request.add_field("Content-Type", "application/json")
  request.body = report.to_json

  client = Net::HTTP.new(splunk_server, splunk_port)

  client.use_ssl = true
  client.verify_mode = OpenSSL::SSL::VERIFY_NONE

  client.request(request)
end

Dir.entries(report_dir).each do |report|
  puts report
  next  if report == '.' or report == '..' 
  path = report_dir + '/' + report
  file = File.read(path)
  report_hash = JSON.parse(file)
  submit_to_splunk(report_hash)
end