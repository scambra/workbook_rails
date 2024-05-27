export RAILS_ENV=test
export BUNDLE_GEMFILE=$PWD/gemfiles/Gemfile-6.0
rm -f spec/dummy/db/test.sqlite3
spec/ci.rb
