require 'securerandom'

begin
  Bundler.require
rescue => e
  raise "Please run with bundle exec"
end

Dir.chdir File.expand_path("../", File.dirname(__FILE__))

def load_files
  #Load settings
  load './config/settings.rb'

  #Load all the initializers
  Dir.chdir "./config/initializers" do
    Dir["*.rb"].each { |f| load "./"+f }
  end

  #Load all lib files
  Dir.glob("./lib/**/*.rb").each { |f| load "./"+f }
end

load_files
