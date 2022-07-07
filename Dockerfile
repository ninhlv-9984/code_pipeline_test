FROM ruby:2.7.5

RUN curl https://deb.nodesource.com/setup_18.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn

WORKDIR /app
COPY . .
RUN bundle install
RUN yarn install

RUN rails db:migrate

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]
