FROM ruby:2.7.4-alpine

RUN apk update && apk add --no-cache nodejs postgresql-client postgresql-libs postgresql-dev
RUN apk add --no-cache --virtual .build-deps build-base ruby-dev libc-dev linux-headers

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

ENV PORT=9292

EXPOSE 9292

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


