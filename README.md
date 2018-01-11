# URL Shortener!

* Versions

This uses Rails version 5 and Ruby 2.3.1, which you can install through RVM or RBEnv if you don't already have them.

* Setup

To start, run `bundle install` to install required dependencies. Then run `bundle exec rake db:setup` to create an empty development database.

Database is currently set to use SQLite3, so you won't need to have any RDBMS server running to do that.

* Running the server

To run the server on port 8889, run `bundle exec rails s -p 8889` (or replace with whatever port you choose, default is 3000)

Have fun and contact me if you have any problems setting it up!
