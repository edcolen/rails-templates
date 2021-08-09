run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# Gems
########################################
inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<-RUBY
  \n
  # Manages user authentication
  gem 'devise'
  \n
  # Manages user authorization
  gem 'pundit'
  \n
  # Enables turbo (Hotwire) functionalities
  gem 'turbo-rails'
  \n
  # Frontend libraries
  gem 'font-awesome-sass'
  gem 'bootstrap', '~> 5.0.1'
  \n
  RUBY
end

gsub_file('Gemfile', /# gem 'rails'/, "'rails', '~> 6.1.4'")

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

# Layout
########################################
inject_into_file 'app/views/layouts/application.html.erb', after: '<body>' do
  <<-HTML
  \n
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
  HTML
end

after_bundle do
  # DB + pages controller
  ########################################
  rails_command 'db:drop db:create db:migrate'
  generate(:controller, 'pages', 'home', '--skip-routes', '--no-test-framework')

  # Root route
  ########################################
  route "root to: 'pages#home'"

  # Devise/Pundit install + user + views
  ########################################
  generate('devise:install')
  generate('devise', 'User')
  generate('devise:views')
  generate('pundit:install')

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

  # For Bootstrap (and icons) in Rails 6.1
  ########################################
  run 'yarn add bootstrap@next @popperjs/core bootstrap-icons'

  append_file 'app/javascript/stylesheets/style.scss', <<~CSS
    @import "bootstrap";
  CSS

  # Tooltips everywhere
  run 'mkdir app/javascript/components'
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/bootstrap_js/init_tooltips.js > app/javascript/components/init_tooltips.js'

  append_file 'app/javascript/packs/application.js', <<~JS
    import "bootstrap";
    import "bootstrap-icons/font/bootstrap-icons.css";
    import { initTooltips } from "../components/init_tooltips";
    initTooltips();
  JS

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

  # App controller
  ########################################
  run 'rm app/controllers/application_controller.rb'
  file 'app/controllers/application_controller.rb', <<~RUBY
    class ApplicationController < ActionController::Base
      protect_from_forgery
      before_action :authenticate_user!
      #{''}
      # Uncomment if user model has additional attributes
      # before_action :configure_permitted_parameters, if: :devise_controller?
      #{''}
      include Pundit
      #{''}
      # Pundit: white-list approach.
      after_action :verify_authorized, except: :index, unless: :skip_pundit?
      after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
      #{''}
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
      #{''}
      def user_not_authorized
        flash[:alert] = 'You are not authorized to perform this action.'
        redirect_to(root_path)
      end
      #{''}
      private
      #{''}
      def skip_pundit?
        devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
      end
      #{''}
      # Uncomment and add keys if user model has additional attributes
      # def configure_permitted_parameters
      #   # For additional fields in app/views/devise/registrations/new.html.erb, e.g. "username"
      #   devise_parameter_sanitizer.permit(:sign_up, keys: %i[username])
      #{''}
      #   # For additional fields in app/views/devise/registrations/edit.html.erb, e.g. "username"
      #   devise_parameter_sanitizer.permit(:account_update, keys: %i[username])
      # end
    end
  RUBY

  # Shared views directory
  ########################################
  run 'mkdir app/views/shared'
  run 'mkdir app/views/shared/components'
  run 'touch app/views/shared/components/.gitkeep'

  # Pages Controller
  ########################################
  run 'rm app/controllers/pages_controller.rb'
  file 'app/controllers/pages_controller.rb', <<~RUBY
    class PagesController < ApplicationController
      skip_before_action :authenticate_user!, only: [ :home ]
      def home
      end
    end
  RUBY

  # Environments / Devise requirements
  ########################################
  environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
  environment 'config.action_mailer.default_url_options = { host: "http://YOUR_DOMAIN" }', env: 'production'

  # Dotenv
  ########################################
  run 'touch .env'

  # Rubocop
  ########################################
  run 'curl -L https://raw.githubusercontent.com/edcolen/rails-templates/master/.rubocop.yml > .rubocop.yml'
end
