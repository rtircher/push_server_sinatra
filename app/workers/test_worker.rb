require 'sidekiq'

class TestWorker
  include Sidekiq::Worker

  def perform
    print "called\n"
  end
end
