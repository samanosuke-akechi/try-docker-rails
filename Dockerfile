# FROM イメージ名:バージョン => イメージはコンテナの土台らしい
FROM ruby:2.7.4

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    nodejs \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /try-docker-rails

WORKDIR /try-docker-rails

COPY Gemfile /try-docker-rails/Gemfile
COPY Gemfile.lock /try-docker-rails/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . /try-docker-rails

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
