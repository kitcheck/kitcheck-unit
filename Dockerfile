FROM 210873117884.dkr.ecr.us-east-1.amazonaws.com/ruby:2.6-trusty

COPY . /app

WORKDIR /app/

RUN rbenv local 2.6.0

RUN bundle install
