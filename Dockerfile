FROM 210873117884.dkr.ecr.us-east-1.amazonaws.com/ruby:3.0-focal

COPY . /app

WORKDIR /app/
RUN gem install bundler -v 1.17.3
RUN bundle install
