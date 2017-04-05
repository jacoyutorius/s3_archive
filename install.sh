#!/bin/sh

bundle install --path .bundle
bundle exec rake build
gem install -l pkg/s3_archive-0.1.0.gem -V