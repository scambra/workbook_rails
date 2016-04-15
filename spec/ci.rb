#!/usr/bin/env ruby

exit system('cd spec/dummy && export BUNDLE_GEMFILE=../../$BUNDLE_GEMFILE && bundle install --without debug && bundle exec rake db:create && bundle exec rake db:migrate && cd ../../ && BUNDLE_GEMFILE=spec/dummy/$BUNDLE_GEMFILE bundle exec rspec spec')
