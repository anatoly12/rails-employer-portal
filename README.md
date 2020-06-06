# MySQL version

Install MySQL 5.7.x (to stay compatible with production version):

https://dev.mysql.com/downloads/mysql/

# Database initialization

To drop the DB, create the DB, run the migrations and the seeds:

- `rake prepare`

# Tests

To run the test suite:

- `bin/rspec`

# Development

In development, we want to run `bin/webpack-dev-server` alongside with `rails server`. For that purpose, we need a tool to manage Procfile-based applications, such as [foreman](https://github.com/ddollar/foreman), [overmind](https://github.com/DarthSim/overmind) or [hivemind](https://github.com/DarthSim/hivemind).

With overmind:

- define `OVERMIND_PROCFILE=Procfile.dev`
- start the server with `overmind start`
- connect to the Rails process for debug purposes with `overmind connect web`

# Compile assets

- `rails webpacker:compile`
