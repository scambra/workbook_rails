export RAILS_ENV=test
export BUNDLE_GEMFILE=$PWD/gemfiles/Gemfile-8.0
rm -f spec/dummy/db/test.sqlite3 spec/dummy/db/schema.rb
spec/ci.rb
