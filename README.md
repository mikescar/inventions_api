[![CircleCI](https://circleci.com/gh/mikescar/inventions_api.svg?style=svg)](https://circleci.com/gh/mikescar/inventions_api)

A sample API implementation that shows some basic style and tooling preferences for Ruby on Rails projects.

The API consumer can view a list of parts ("bits"), and specify inventions
based on those parts. Read basic API docs [here](https://github.com/mikescar/inventions_api/wiki/How-to-Use). A hosted version lives at `inventions-api.herokuapp.com`.

This app has been `docker`-ized, but it is not required if you prefer the traditional rails (and Heroku) workflow.
Instructions below are provided for a 'local' rails environment, and the docker one. _Don't use both! :)_

## System dependencies
The Ruby on Rails app itself uses `ruby 2.5.x` and `postgres 10.4.x`.

## Local
`gem install bundler && bundle install`

### Docker
Development environment requires support for `docker-compose` version 2.

To build initial containers: `docker-compose build`. Also run this after changing docker configs
(`Dockerfile`, `docker-compose.yml`).


## Development database creation

### Local
Set your `ENV['DATABASE_URL']` using format: `postgres://#{username}@#{hostname}:#{port}/#{database}`

`rails db:create && rails db:migrate && rails db:migrate RAILS_ENV=test`

### Docker
Create a `docker/web.env` file containing these two `DATABASE_URL` values, and your other app secrets (the file is git-ignored):

```
BUNDLE_CONTRIBSYS_KEY=aaaaaaaaaaaaaaa
DATABASE_URL=postgres://postgres@db:5432/inventions-api
DATABASE_URL_TEST=postgres://postgres@db:5432/inventions-api_test
SECRET_KEY_BASE=bbbbbbbbbbbbbbbbbbbb
```

Then run:

```
docker-compose run web rails db:create
docker-compose run web rails db:migrate
docker-compose run web rails db:schema:load RAILS_ENV=test
```

## Running development environment

### Local
`rails server`

### Docker
`docker-compose up` or `docker-compose up -d` if you want it to run in the background.


## Running tests

### Local
Just run `rspec`, or `rspec spec/models` or the like to run a subset of tests. To run only the tests
that failed last time, use `rspec --only-failures`.

### Docker
`docker-compose run --rm web bundle exec rspec`, OR `docker exec -it inventions_api_web_1 bundle exec rspec` will execute in the already-running container. Or `docker exec -it inventions_api_web_1 spring rspec` if you wanna go fast.


## Heroku deployment
Create a heroku app, and after initial deployment plug your APP_NAME into:

```
heroku addons:create heroku-postgresql -a APP_NAME
heroku run rails secrets:setup -a APP_NAME
```

## Local / Traditional
Nothing else needs to be done.

## Docker
```
heroku container:login
heroku container:push -a APP_NAME
heroku container:release -a APP_NAME
```

## Other notes
I'm keeping old branches around to show I don't really work on master directly, but on real projects
I do prefer to delete branches after merging them.


## TODO
- Create and push docker containers from CircleCI to Heroku, skip the 
- Add support for new `heroku.yml` to enable docker containers in Heroku review apps.
