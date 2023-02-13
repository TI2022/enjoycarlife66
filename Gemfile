source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'kaminari', :git => 'https://github.com/kaminari/kaminari'
gem 'faker'
gem 'enum_help'

# devise関連のgem
gem "devise"
gem "devise-i18n"
gem "devise-i18n-views"
gem 'jp_prefecture'

# line関連のgem
gem 'omniauth-line'
gem 'dotenv-rails'
gem "omniauth-rails_csrf_protection"

# 画像のアップロード機能
gem 'carrierwave'
# 検索機能
gem 'ransack'
gem 'payjp'
gem 'quilljs-rails', :git => 'https://github.com/abhinavmathur/quilljs-rails.git' # エラーが出たのでhttpsに変更しました
gem 'spring'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :production do
  gem 'rails_12factor' # herokuで詳細なログを出す
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
