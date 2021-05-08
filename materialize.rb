run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# Gems
########################################
inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<-RUBY
  \n
  # Enables turbo (Hotwire) functionalities
  gem 'turbo-rails'
  \n
  RUBY
end

gsub_file('Gemfile', /# gem 'rails'/, "'rails', '~> 6.1.3.2'")

inject_into_file 'Gemfile', after: 'group :development, :test do' do
  <<-RUBY
  gem 'capybara'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  RUBY
end

# Assets
########################################
run 'rm -rf app/assets/stylesheets/application.css'
run 'touch app/assets/stylesheets/application.scss'
run 'mkdir app/assets/stylesheets/components'
run 'touch app/assets/stylesheets/components/_index.scss'
run 'mkdir app/assets/stylesheets/config'
run 'touch app/assets/stylesheets/config/_index.scss'
run 'touch app/assets/stylesheets/config/_colors.scss'
run 'touch app/assets/stylesheets/config/_fonts.scss'

append_file 'app/assets/stylesheets/config/_index.scss', <<~CSS
  @import "colors";
  @import "fonts";
CSS

append_file 'app/assets/stylesheets/application.scss', <<~CSS
  @import "config/index";
  @import "components/index";
CSS

# Webpacker stylesheets
########################################
run 'mkdir app/javascript/stylesheets'
run 'touch app/javascript/stylesheets/style.scss'

append_file 'app/javascript/packs/application.js', <<~JS
  import "../stylesheets/style";
JS

inject_into_file 'app/views/layouts/application.html.erb',
                 after: "<%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>" do
  <<-HTML
  \n
    <%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
  HTML
end

after_bundle do
  # DB
  ########################################
  rails_command 'db:drop db:create db:migrate'

  # Tests
  ########################################
  generate('rspec:install')
  gsub_file('spec/rails_helper.rb', /config.use_transactional_fixtures = true/,
            'config.use_transactional_fixtures = false')
  inject_into_file 'spec/rails_helper.rb', after: 'config.use_transactional_fixtures = false' do
    <<-RUBY
    \n
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
      DatabaseCleaner.start
      DatabaseCleaner.clean
    end

    config.before(:each) do
      DatabaseCleaner.clean
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.after(:suite) do
      DatabaseCleaner.clean
    end

    config.include Devise::Test::ControllerHelpers, type: :controller
    config.include FactoryBot::Syntax::Methods
    RUBY
  end

  # Hotwire
  run 'rails turbo:install'

  # StimulusJS
  run 'yarn add stimulus'
  run 'mkdir app/javascript/controllers'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/stimulus_js/hello_controller.js > app/javascript/controllers/hello_controller.js'

  inject_into_file 'app/javascript/packs/application.js', after: 'import "channels"' do
    <<~JS
      #{''}
      import { Application } from "stimulus";
      import { definitionsFromContext } from "stimulus/webpack-helpers";
      #{''}
      const application = Application.start();
      const context = require.context("../controllers/", true, /\.js$/);
      application.load(definitionsFromContext(context));
      #{''}
    JS
  end

  # For Materialize CSS in Rails 6.1
  ########################################
  run 'yarn add materialize-css'

  append_file 'app/javascript/stylesheets/style.scss', <<~CSS
    @import "materialize-css/dist/css/materialize";
  CSS

  # Materialize components inits
  run 'mkdir app/javascript/components'
  run 'mkdir app/javascript/components/materialize'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/autocomplete.js > app/javascript/components/materialize/autocomplete.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/carousel.js > app/javascript/components/materialize/carousel.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/charactercounter.js > app/javascript/components/materialize/charactercounter.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/chips.js > app/javascript/components/materialize/chips.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/collapsible.js > app/javascript/components/materialize/collapsible.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/datepicker.js > app/javascript/components/materialize/datepicker.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/dropdown.js > app/javascript/components/materialize/dropdown.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/featurediscovery.js > app/javascript/components/materialize/featurediscovery.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/floatingactionbutton.js > app/javascript/components/materialize/floatingactionbutton.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/media.js > app/javascript/components/materialize/media.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/modal.js > app/javascript/components/materialize/modal.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/parallax.js > app/javascript/components/materialize/parallax.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/pushpin.js > app/javascript/components/materialize/pushpin.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/scrollspy.js > app/javascript/components/materialize/scrollspy.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/select.js > app/javascript/components/materialize/select.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/sidenav.js > app/javascript/components/materialize/sidenav.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/tabs.js > app/javascript/components/materialize/tabs.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/timepicker.js > app/javascript/components/materialize/timepicker.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/tooltips.js > app/javascript/components/materialize/tooltips.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/components/waves.js > app/javascript/components/materialize/waves.js'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/materialize_js/init_materialize.js > app/javascript/components/init_materialize.js'

  append_file 'app/javascript/packs/application.js', <<~JS
    import 'materialize-css/dist/js/materialize'
    #{''}
    import { initMaterialize } from "../components/init_materialize";
    initMaterialize();
  JS

  # Material icons
  inject_into_file 'app/views/layouts/application.html.erb',
                   after: "<%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>" do
    <<-HTML
    \n
      <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    HTML
  end

  # Git ignore
  ########################################
  append_file '.gitignore', <<~TXT
    # Ignore .env file containing credentials.
    .env*
    #{''}
    # Ignore Mac and Linux file system files
    *.swp
    .DS_Store
    #{''}
    # Ignore node modules
    /node_modules
  TXT

  # Shared views directory
  ########################################
  run 'mkdir app/views/shared'
  run 'mkdir app/views/shared/components'
  run 'touch app/views/shared/components/.gitkeep'

  # Dotenv
  ########################################
  run 'touch .env'

  # Rubocop
  ########################################
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/.rubocop.yml > .rubocop.yml'
end
