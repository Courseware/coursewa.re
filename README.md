![Coursewa.re Logo](https://raw.github.com/Courseware/coursewa.re/master/public/logo.png)

# The Courseware Project

[![Build Status](https://travis-ci.org/Courseware/coursewa.re.png?branch=master)](https://travis-ci.org/Courseware/coursewa.re)

Courseware is a learning management system written in Ruby (Rails).

Courseware was open sourced on 10th Nov 2013.
Please, If you find troubles installing or using Courseware because of some
private version assets/settings open an issue so we can fix.

Below you can find some developer oriented docs to help you bring up the
environment and just hack around.

## Installation

1. Clone the repository
2. Run `bundle install`
3. Run migrations `bundle exec rake db:create db:migrate db:test:prepare`
4. Install some seed data `rake db:seed:development`
5. Run `rails s`
6. Open your browser and navigate to `http://lvh.me:3000`

You are all set now! Use you local system username (ex.: `ENV['USER']`) or `dev`
and append `@coursewa.re` to get the seeded user email account.
Your password is `secret` (the same for any pre-seeded user).

## Usage

Courseware (non Rails) settings can be found
in the `config/initializers/8_courseware.rb` file.

The includes settings for default email, allowed sub-domains, image sizes,
subscription plans and other options.

For a full list of options, check the `coursewareable` project which is the
core of the application.

You can use any database supported by Active Record.
We recommend you PostgreSQL if you plan to use it in production.

Courseware uses `Delayed::Job` for background processing. If you plan to use it
in production, please take a look on how we suggest deploying it.

## Development

If you write Ruby, we recommend using
[GitHub code style](https://github.com/styleguide/ruby).

We use YARD for documentation. The simple rule is to have
at least one line that describes the module, class or method you wrote.

Courseware UI uses a lot of [Zurb Foundation](http://foundation.zurb.com/)
components. The library we use is still at v3.

### QA

We spent a lot of time maintaining the code quality and tests coverage at a
high level. If you decide to create a pull request, please consider
providing tests too.
It will speed up the acceptance rate and save time for everyone.

To run some quality checks use the rake task: `bundle exec rake qa`

## Deploying Courseware

Courseware uses `mina` for deployments. Please check the `config/deploy.rb` file
for if you want to set it up.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Courseware was built using a lot of awesome libraries,
for which we are thankful to their authors/contributors.
