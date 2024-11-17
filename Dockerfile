FROM ruby:3.3.6-slim

# Install dependencies for Rails and MySQL
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    nodejs \
    curl \
    libmariadb-dev && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /rails

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the app code
COPY . .

#I using db reset since i'm not using volume for mysql container so I need seeding data every time
CMD ["bash", "-c", "./wait-for-it.sh db:3306 -- bundle exec rails db:reset && bundle exec rails server -b 0.0.0.0 -p 3000"]
