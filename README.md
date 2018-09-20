[![CircleCI](https://circleci.com/gh/mikescar/inventions_api.svg?style=svg)](https://circleci.com/gh/mikescar/inventions_api)
[![codecov](https://codecov.io/gh/mikescar/inventions_api/branch/master/graph/badge.svg)](https://codecov.io/gh/mikescar/inventions_api)

A sample API implementation that shows some basic style, tooling, and workflow preferences for Ruby on Rails projects.

The API consumer can view a list of parts ("bits"), and specify inventions
based on those parts. Read basic API docs [here](https://github.com/mikescar/inventions_api/wiki/How-to-Use). A hosted version lives at `inventions-api.herokuapp.com`.

This app has been `docker`-ized, but it is not required if you only want the rails project.

## System dependencies
The Ruby on Rails app itself uses `ruby 2.5.x` and `postgres 10.4.x`. Docker needs `docker-compose` v2+, which you probably already have if you are dockerizing.

[Install/test/build/deploy instructions with and without `docker`](https://github.com/mikescar/inventions_api/wiki)
