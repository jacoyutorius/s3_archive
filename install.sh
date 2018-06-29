#!/bin/sh

bundle install
bundle exec rake build
gem install -l pkg/s3_archive-0.4.1.gem -V
