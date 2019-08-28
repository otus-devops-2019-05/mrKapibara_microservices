FROM ruby:2.4.2

COPY ./ /app/
WORKDIR /app

RUN bundle install

CMD ["puma"]

