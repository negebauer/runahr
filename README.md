# Runa HR Attendance API

Check the [documentation](https://documenter.getpostman.com/view/1018411/SW7T7Wzc)
View the [api live](https://runahr-attendance.herokuapp.com/)

## Environment

- Ruby 2.5.1
- Rails 5.2.3
- PostgreSQL 12
- [Circle CI](https://circleci.com/gh/negebauer/runahr)
- [Heroku](https://runahr-attendance.herokuapp.com)

## Development

- Clone and cd to this repository
- Run `bundle install`
- Create a credential for running locally `bundle exec rake secret > config/master.key`
- Run postgress in default port
- Run `bundle exec rake db:create db:migrate`
- Run `bundle exec rails s`

### Lint

Run `bundle exec rubocop`

### Test

Run `bundle exec rake test`
