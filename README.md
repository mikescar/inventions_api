The following steps will get this project up and running.

## System dependencies
Ruby 2.5.1+, Postgresql 10+

Assuming you have ruby installed, run `bundle install`


## Local database creation & (re-)initialization
If you don't care what the databases are named, just run the command below. Otherwise, first set ENV vars for `BITS_DATABASE_DEVELOPMENT` and `BITS_DATABASE_TEST`, then run command.

`rails db:reset; rails db:migrate; rails db:migrate RAILS_ENV=test`


## Running tests
Just run `rspec`, or `rspec spec/models` or the like to run a subset of tests. To run only the tests
that failed last time, use `rspec --only-failures`.


* Deployment instructions
