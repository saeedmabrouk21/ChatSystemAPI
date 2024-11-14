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

CMD ["rails", "server", "-b", "0.0.0.0"]
