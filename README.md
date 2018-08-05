A sample API implementation that shows some basic style and gem preferences for Ruby on Rails projects.

The API consumer can view a list of parts ("bits"), and specify inventions
based on those parts. Read basic API docs [here](https://github.com/mikescar/inventions_api/wiki/How-to-Use). A hosted version lives at `inventions-api.herokuapp.com`.

## System dependencies
Ruby 2.5.1+, Postgresql 10+

Assuming you have ruby installed, run `bundle install`


## Local database creation & (re-)initialization
If you don't care what the databases are named, just run the command below. Otherwise, set your ENV vars for `BITS_DATABASE_DEVELOPMENT` and `BITS_DATABASE_TEST`, then run command.

`rails db:reset; rails db:migrate; rails db:migrate RAILS_ENV=test`


## Running tests
Just run `rspec`, or `rspec spec/models` or the like to run a subset of tests. To run only the tests
that failed last time, use `rspec --only-failures`.


## Heroku deployment
Create a heroku app, and after initial deployment plug your APP_NAME into:
```
heroku addons:create heroku-postgresql -a APP_NAME
heroku run rails secrets:setup -a APP_NAME
heroku run rails db:migrate -a APP_NAME
```

## Other notes
I'm leaving branches here to show I didn't really work on master directly, but I prefer to delete
them after merging to master.
