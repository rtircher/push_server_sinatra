web:    bundle exec rerun rackup
worker: bundle exec sidekiq -r ./app/workers/test_worker.rb
clock:  bundle exec clockwork clock.rb
mongo:  ./go
redis:  redis-server /usr/local/etc/redis.conf
