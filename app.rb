require 'sinatra'
require 'apns'
require 'mongo'

include Mongo

@@client = MongoClient.new('localhost', 27017)
@@db     = @@client['device-db']
@@tokens = @@db['tokens']
@@tokens.create_index("user_id")

###################
# Hosts Config
###################

# Push Notification Service:
#
# (default: gateway.sandbox.push.apple.com is)
# Set as below for a production install
# APNS.host = 'gateway.push.apple.com' 

# (default: 2195)
# APNS.port = 2195

# Feedback Service:
#
# (default: feedback.sandbox.push.apple.com)
# APNS.feedback_host = 'feedback.push.apple.com'
# (development: feedback.sandbox.push.apple.com)
APNS.feedback_host = 'feedback.sandbox.push.apple.com'

# (default: 2196)
# APNS.feedback_port = 2196

####################
# Certificate Setup
####################

# Path to the .pem file created earlier
APNS.pem  = 'tools/development.pem'

# Password for decrypting the .pem file, if one was used
# APNS.pass = 'xxxx'

####################
# Connection Mgmt
####################

# Cache open connections when sending push notifications
# this will force the gem to keep 1 connection open per
# host/port pair, and reuse it when sending notifications

# (default: false)
# APNS.cache_connections = true

get '/users/:id/notifications' do |user_id|
  user = @@tokens.find_one( "user_id" => user_id )
  return "User #{user_id} not found" unless user

  device_token = user["token"]

  if device_token
    # Single notification
    APNS.send_notification(device_token, "Hello iPhone with token #{device_token}")
    # APNS.send_notification(device_token, :aps => {:alert => 'Notification 2: Hello iPhone!', :badge => 1, :sound => 'default'})

    # multiple notifications at once
    # n1 = [device_token, :aps => { :alert => 'Hello...', :badge => 1, :sound => 'default' }]
    # n2 = [device_token, :aps => { :alert => '... iPhone!', :badge => 1, :sound => 'default' }]
    # APNS.send_notifications([n1, n2])

    "Notifications Sent"
  else
    "No device token found for user #{user_id}"
  end
end

post '/users/:id/devices' do |user_id|
  @@tokens.remove({ "user_id" => user_id })
  @@tokens.insert({ "user_id" => user_id, "token" => params[:token] }) # need to have a set of token and add token ids when requested

  @@tokens.find.each { |token| p token }

  status(200)
end

get '/feedback' do
  # APNS.feedback_each returns an array of Hash objects with the following keys
  # :feedback_on => (Time) Time Apple considers app unregistered from device
  # :length => (Fixnum) Length of :device_token, currently always 32 (bytes)
  # :device_token => (String) hex-encoded device token
  p "Feedback check begin"
  APNS.feedback.each do |feedback|
    @@tokens.remove({ "token" => feedback.device_token })
  end
  p "Feedback check end"
end
