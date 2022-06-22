FROM 210873117884.dkr.ecr.us-east-1.amazonaws.com/ruby:2.6-alpine

COPY . /app

WORKDIR /app/
RUN gem install bundler -v 2.3.16
RUN bundle install
