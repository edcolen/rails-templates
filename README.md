# Rails Templates

Some useful templates to get rails apps up and running with some nice starter configuration out of the box.

All templates are Rails 6.1.4 with [Hotwire](https://hotwire.dev/) (Turbo and Stimulus) installed and configured.

For tests, they have [RSpec](https://rspec.info/), along with `pry-byebug`, `pry-rails`, `capybara`, `database_cleaner` and `factory_bot_rails`. Other options with minitest will be added in time.

The DB of choice is `Postgresql`, but that can be changed the appropriate flags in the commands below.

Since `Sprockets` and `Webpacker` coexist in Rails 6, the `stylesheet_link_tag` was kept along with the `stylesheet_pack_tag` in `application.html`. So it's possible to use the assets pipeline while `Wepacker` handles some js styles.

## Minimum (RSpec)

Minimum template with just Hotwire and test suite installed.

```bash
rails new \
  --database postgresql \
  -m https://raw.githubusercontent.com/edcolen/rails-templates/master/minimum.rb \
  -T \
  YOUR_APP_NAME
```

## Bootstrap 5 (RSpec)

Minimum template with [Bootstrap 5](https://getbootstrap.com/docs/5.0/getting-started/introduction/).

```bash
rails new \
  --database postgresql \
  -m https://raw.githubusercontent.com/edcolen/rails-templates/master/bootstrap5.rb \
  -T \
  YOUR_APP_NAME
```

## Devise & Bootstrap 5 (RSpec)

Template for apps that require user authorization & authentication, with [Bootstrap 5](https://getbootstrap.com/docs/5.0/getting-started/introduction/). It includes a pages controller (with home action routed as root).
Main gems:

- Devise
- Pundit

```bash
rails new \
  --database postgresql \
  -m https://raw.githubusercontent.com/edcolen/rails-templates/master/devise-bootstrap5.rb \
  -T \
  YOUR_APP_NAME
```

## Devise & Bootstrap 5 (Minitest)

Template for apps that require user authorization & authentication, with [Bootstrap 5](https://getbootstrap.com/docs/5.0/getting-started/introduction/). It includes a pages controller (with home action routed as root).
Main gems:

- Devise
- Pundit

```bash
rails new \
  --database postgresql \
  -m https://raw.githubusercontent.com/edcolen/rails-templates/master/devise-bootstrap5-minitest.rb \
  YOUR_APP_NAME
```

## Materialize CSS (RSpec)

Minimum template with [Materialize CSS](https://materializecss.com/).
The JS components are imported from individual files, so options can be passed instead of a global initialization.

```bash
rails new \
  --database postgresql \
  -m https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize.rb \
  -T \
  YOUR_APP_NAME
```

## Devise & Materialize CSS (RSpec)

Template for apps that require user authorization & authentication, with [Materialize CSS](https://materializecss.com/).
The JS components are imported from individual files, so options can be passed instead of a global initialization. It also includes a pages controller (with home action routed as root).
Main gems:

- Devise
- Pundit

```bash
rails new \
  --database postgresql \
  -m https://raw.githubusercontent.com/edcolen/rails-templates/master/devise-materialize.rb \
  -T \
  YOUR_APP_NAME
```
