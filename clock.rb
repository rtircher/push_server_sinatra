# Sidekiq defers scheduling to other, better suited gems.
# If you want to run a job regularly, here's an example
# of using the 'clockwork' gem to push jobs to Sidekiq
# regularly.

# require boot & environment for a Rails app
# require_relative "../config/boot"
# require_relative "../config/environment"
require "clockwork"
require "./app/workers/test_worker"

# class MyWorker
#   include Sidekiq::Worker

#   def perform(count)
#     puts "Job ##{count}: Late night, so tired..."
#   end

#   def self.late_night_work
#     10.times do |x|
#       perform_async(x)
#     end
#   end
# end

module Clockwork
  every 1.day, 'deal.notifications.job', :at => '10:00' do
  end

  every 10.second, 'test.job' do
    TestWorker.perform_async
  end
end
