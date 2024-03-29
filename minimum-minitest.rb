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

gsub_file('Gemfile', /# gem 'rails'/, "'rails', '~> 6.1.4'")

inject_into_file 'Gemfile', after: 'group :development, :test do' do
  <<-RUBY
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'pry-rails'
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
