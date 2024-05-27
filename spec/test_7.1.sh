export RAILS_ENV=test
export BUNDLE_GEMFILE=$PWD/gemfiles/Gemfile-7.1
rm -f spec/dummy/db/test.sqlite3
spec/ci.rb
