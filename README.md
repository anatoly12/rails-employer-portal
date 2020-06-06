# MySQL version

Find a version compatible with production (MySQL Community Server 5.7.x) at:

https://dev.mysql.com/downloads/mysql/

# Database initialization

Drop the development DB, create the development DB, run the migrations and the seeds then prepare the tests all-in-one:

- `rake prepare`

# Tests

To run the test suite:

- `bin/rspec`

# Development

Add into you local hosts file (`/etc/hosts` for Linux/MacOS, `C:\Windows\System32\drivers\etc\hosts` for Windows):

```
127.0.0.1   employer-portal.test
```

In development, we want to run `bin/webpack-dev-server` alongside with `rails server`. For that purpose, we need a tool to manage Procfile-based applications, such as [foreman](https://github.com/ddollar/foreman), [overmind](https://github.com/DarthSim/overmind) or [hivemind](https://github.com/DarthSim/hivemind).

With overmind:

- define `OVERMIND_PROCFILE=Procfile.dev`
- start the server with `overmind start`
- connect to the Rails process for debug purposes with `overmind connect web`

# Compile assets for production

- `rails webpacker:compile`

# Deploy
