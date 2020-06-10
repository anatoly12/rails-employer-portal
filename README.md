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

## Reformat JS automatically

- `npx prettier --config app/javascript/src/prettier.config.js --write app/javascript/src/index.js`

## Compile assets for production

- `RAILS_ENV=production NODE_ENV=production rails webpacker:compile`

## Deploy
