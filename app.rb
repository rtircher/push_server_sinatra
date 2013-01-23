require 'sinatra'
require 'apns'

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

get '/notification' do
  device_token = 'bab40d7ddab5a6fca09eb2ab13fc5cd046da9064c4174f7e62c45477fd3a4656'

  # Single notification
  APNS.send_notification(device_token, 'Notification 1: Hello iPhone!')
  APNS.send_notification(device_token, :aps => {:alert => 'Notification 2: Hello iPhone!', :badge => 1, :sound => 'default'})

  # multiple notifications at once
  n1 = [device_token, :aps => { :alert => 'Hello...', :badge => 1, :sound => 'default' }]
  n2 = [device_token, :aps => { :alert => '... iPhone!', :badge => 1, :sound => 'default' }]
  APNS.send_notifications([n1, n2])

  "Notifications Sent"
end
