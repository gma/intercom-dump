FROM ruby:2.5.3

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN useradd -m app
USER app

CMD ["bash"]
