#!/usr/bin/env ruby
# frozen_string_literal: true

exit system('cd spec/dummy && bundle install && bundle exec rake db:create && bundle exec rake db:migrate && cd ../../ && bundle exec rspec spec')
