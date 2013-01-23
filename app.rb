require 'sinatra'
require 'apns'

@@users = {}

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
APNS.feedback_host = 'feedback.push.apple.com'

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

get '/users/:id/notify' do |user_id|
  return "User #{user_id} not found" unless users[user_id]

  device_token = users[user_id][:token]

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
    "No device token found for user #{users[user_id]}"
  end
end

post '/users/:id/registerDevice' do |user_id|
  users[user_id] = { :token => params[:token] } # need to have a set of token and add token ids when requested

  status(200)
end

private

def users
  @@users
end
