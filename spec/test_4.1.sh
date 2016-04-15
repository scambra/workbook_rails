export RAILS_ENV=test
export BUNDLE_GEMFILE=gemfiles/Gemfile-4.1
rm -f spec/dummy/db/test.sqlite3
spec/ci.rb
