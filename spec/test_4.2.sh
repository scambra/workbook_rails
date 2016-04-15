export RAILS_ENV=test
export BUNDLE_GEMFILE=../../Gemfile
rm -f spec/dummy/db/test.sqlite3
spec/ci.rb
