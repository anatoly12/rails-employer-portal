# ---- Build Stage - ruby ----
FROM ruby:2.7.1 AS builder

# Install node
RUN apt-get update && \
  apt-get install -y yarnpkg && \
  ln -nsf /usr/bin/yarnpkg /usr/bin/yarn

# Set environment variables for building the application
ENV RAILS_ENV=production

# Create the application build directory
RUN mkdir /home/app
WORKDIR /home/app

# Cache deps fetching/compilation until Gemfile or Gemfile.lock changes
COPY Gemfile Gemfile.lock ./

# Fetch the application dependencies and build the application
RUN bundle config deployment true && \
  bundle config jobs 4 && \
  bundle install

# Install JS dependencies
COPY package.json yarn.lock ./

# Fetch the application dependencies and build the application
RUN yarn install --frozen-lockfile

# Copy the whole project into /home/app
COPY . .

# Compile static assets
RUN ./bin/rails webpacker:compile

# ---- Application stage ----
FROM ruby:2.7.1-slim AS app

ENV LANG=C.UTF-8
ENV TZ=utc

# Install mysql client
RUN apt-get update && \
  apt-get install -y default-libmysqlclient-dev && \
  rm -rf /var/lib/apt/lists/*

# Copy over the build artifact from the previous step and create a non root user
RUN useradd -m app
WORKDIR /home/app
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --chown=app Procfile.prod ./Procfile
COPY --chown=app --from=builder /home/app .
USER app

# Run the Rails app
CMD ["./bin/puma", "-C", "config/puma.rb"]
