#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails webpacker:install
yarn install
bundle exec rake assets:precompile
bin/webpack
rails db:migrate
