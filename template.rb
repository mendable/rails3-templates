rvmrc = <<-RVMRC
rvm 1.9.2@#{app_name}
rvm_gemset_create_on_use_flag=1
rvm gemset use #{app_name}
RVMRC

create_file ".rvmrc", rvmrc

gem "mysql"
gem "authlogic"
gem "haml"
gem "capybara", :group => [:test, :cucumber]
gem "cucumber", :group => [:test, :cucumber]
gem "cucumber-rails", :group => [:test, :cucumber]
gem "database_cleaner", :group => [:test, :cucumber]
gem "factory_girl_rails", :group => [:test, :cucumber]
gem "launchy", :group => [:test, :cucumber] # so you can do then show me the page in cucumber
gem "rspec-rails", ">= 2.0.0.beta.20", :group => [:test, :cucumber]
gem "spork", :group => [:test, :cucumber]
gem "pickle", :group => [:test, :cucumber]
gem "timecop", :group => [:test, :cucumber]

generators = <<-GENERATORS
    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.intergration_tool :rspec
    end
GENERATORS

application generators

remove_file "public/javascripts/"

get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js jquery-ui.js rails.js)'

layout = <<-LAYOUT
!!!
%html
  %head
    %title #{app_name.humanize}
    = stylesheet_link_tag :all
    = javascript_include_tag :defaults
    = csrf_meta_tag
  %body
    = yield
LAYOUT

remove_file "app/views/layouts/application.html.erb"
create_file "app/views/layouts/application.html.haml", layout

remove_file "README"
remove_file "public/index.html"
remove_file "public/favicon.ico"
remove_file "doc/README_FOR_APP"
remove_file "public/images/rails.png"

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"


database_yml = <<-DATABASE
development:
  adapter: mysql
  database: #{app_name}_development
  username: root
  password:
  encoding: utf8

test:
  adapter: mysql
  database: #{app_name}_test
  username: root
  password:
  encoding: utf8

production:
  adapter: mysql
  database: #{app_name}_production
  username: root
  password:
  encoding: utf8

cucumber:
  <<: *test
DATABASE

remove_file "config/database.yml"
create_file "config/templates/database.yml", database_yml
create_file "config/database.yml", database_yml


git :init
git :add => "."


docs = <<-DOCS

Run the following commands to complete the setup of #{app_name.humanize}:

cd #{app_name}
gem install bundler
bundle install
script/rails generate rspec:install
script/rails generate cucumber:install --rspec --capybara

DOCS

log docs
