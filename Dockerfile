FROM 210873117884.dkr.ecr.us-east-1.amazonaws.com/ruby:2.6-alpine

COPY . /app

WORKDIR /app/
RUN gem install bundler -v 1.17.3
RUN gem install concurrent-ruby -v 1.1.5
RUN gem install minitest -v 5.12.2
RUN gem install tzinfo -v 1.2.5
RUN gem install activesupport -v 5.2.3
RUN gem install method_source -v 0.9.2
RUN gem install i18n -v 1.5.1
RUN gem install rake -v 11.3.0
RUN gem install shoulda -v 3.5.0
RUN gem install pry -v 0.12.2
RUN gem install pry-byebug -v 2.0
RUN gem install racc -v 1.4.15
RUN gem install rexical -v 1.0.7
RUN bundle install --local
