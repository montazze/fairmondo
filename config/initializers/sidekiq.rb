#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# Config Redis

# This code is responsible for loading the sidekiq-pro gem, which is NOT installed
# via bundler
begin
  file = YAML.load_file("#{Rails.root}/config/sidekiq_pro_path.yml")
  path = file['path']
  $LOAD_PATH.unshift(path)
rescue
  puts 'sidekiq_pro_path.yml not found'
end

begin
  require 'sidekiq-pro'
  Sidekiq::Client.reliable_push!
rescue LoadError, NoMethodError
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://10.0.2.181:6379', namespace: 'fairnopoly' } if Rails.env.production?
  begin
    config.reliable_fetch!
  rescue NoMethodError
  end
end

if Rails.env.production?
  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://10.0.2.181:6379', namespace: 'fairnopoly' }
  end
end

Redis.current = SidekiqRedisConnectionWrapper.new
