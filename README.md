# Employer Portal

Employer Portal for Digital Health Passport

## MySQL version

Find a version compatible with production (MySQL Community Server 5.7.x) at:

https://dev.mysql.com/downloads/mysql/

## Database initialization

Drop the development DB, create the development DB, run the migrations and the seeds then prepare the tests all-in-one:

- `rake prepare`

## Tests

To run the test suite:

- `bin/rspec`

## Development

Install dependencies:

On MacOS with install with homebrew:

```
brew install openssl mysql@5.7 yarn hivemind
brew link --force mysql@5.7
```

Then run `bundler` and `yarn` to get deps:

```
bundle config build.mysql2 --with-ldflags=-L/usr/local/Cellar/openssl@1.1/1.1.1g/lib --with-cppflags=-I/usr/local/Cellar/openssl@1.1/1.1.1g/include`
bundle install
yarn install
```

Add into you local hosts file (`/etc/hosts` for Linux/MacOS, `C:\Windows\System32\drivers\etc\hosts` for Windows):

```
127.0.0.1   employer-portal.test
```

In development, we want to run `bin/webpack-dev-server` alongside with `rails server`. For that purpose, we need a tool to manage Procfile-based applications, such as [foreman](https://github.com/ddollar/foreman), [overmind](https://github.com/DarthSim/overmind) or [hivemind](https://github.com/DarthSim/hivemind).

With overmind:

- define `OVERMIND_PROCFILE=Procfile.dev`
- start the server with `overmind start`
- connect to the Rails process for debug purposes with `overmind connect web`

## Reformat Ruby automatically

- `bin/rufo .`

## Reformat JS automatically

- `npm run format`

## Compile assets for production

- `RAILS_ENV=production NODE_ENV=production rails webpacker:compile`

## Deploy

Use the provided `Dockerfile` and don't forget to run the migrations on each release with:

- `./bin/rails db:migrate`

In addition, you need to define the following environment variables:

- `TZ="utc"`
- `LANG="en_US.UTF-8"`
- `RACK_ENV="production"`
- `RAILS_ENV="production"`
- `DATABASE_URL="mysql2://username:password@host:port/dbname?charset=utf8mb4&collation=utf8mb4_unicode_ci"`
- `SYNC_DATABASE_URL="mysql2://username:password@host:port/ecp-prod?charset=utf8&collation=utf8_general_ci"`
- `AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"`
- `AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"`
- `S3_PREFIX="prod"`
- `MAILER_ADDRESS="email-smtp.us-east-1.amazonaws.com"`
- `MAILER_USERNAME="XXXXXXXXXX"`
- `MAILER_PASSWORD="XXXXXXXXXX"`

As displayed in these examples, notice the difference in charset and collation:

- the new database (specific to Employer Portal) uses `utf8mb4` and `utf8mb4_unicode_ci`
- the old database (shared with the other portals) uses `utf8` and `utf8_general_ci`

Due to the way the sync works at the moment, the app requires the user for the new database/schema to also have access to the old database/schema, allowing to reuse the same connection for faster performance.

It's possible to tweak the number of web server threads and the size of the DB connection pool with the following environment variable:

- `RAILS_MAX_THREADS=5`

Allow background jobs to be processed by running the following process:

- `bin/delayed_job run`

To push logs toward STDOUT instead of `log/production.log` just add the `RAILS_LOG_TO_STDOUT` environment variable with any value, for example:

- `RAILS_LOG_TO_STDOUT="1"`
