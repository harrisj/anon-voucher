FROM ruby:3.4.2

# Copy the application files
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --without=development

ADD . /app
RUN rake db:create
RUN rake db:reseed

EXPOSE 8080

# Set the default command to run the app using rackup
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "8080"]