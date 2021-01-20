# Rails Templates

Some useful templates to get rails apps up and running with some nice starter configuration out of the box.
All templates are for Rails 6.1 & `Hotwire` installed and configured.
For tests, they have `RSpec`, along with `pry-byebug`, `pry-rails`, `capybara`, `database_cleaner` and `factory_bot_rails`.
My DB of choice is `Postgresql`, but that can be changed the appropriate flags in the commands below.

## Bootstrap 5
Minimum template with Bootstrap 5.

```bash
rails new \
  --database postgresql \
  -m https://raw.githubusercontent.com/edcolen/rails-templates/master/bootstrap5.rb \
  -T \
  YOUR_APP_NAME
```

## Devise & Bootstrap 5
Template for apps that require user authorization & authentication.
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
