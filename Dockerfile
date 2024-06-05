FROM ruby:2.7.7

WORKDIR /docker/app

RUN apt-get update && apt-get install -y postgresql-client

RUN gem install bundler -v 2.4.22

COPY Gemfile* ./

RUN bundle install

COPY . .

COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ARG DEFAULT_PORT 3000
EXPOSE ${DEFAULT_PORT}

ENTRYPOINT ["entrypoint.sh"]

CMD [ "bundle","exec", "puma"]