include File.expand_path("./config/init.rb", File.dirname(__FILE__))

class Test < Thor
  desc "example FILE", "an example task that does something with a file"
  def example(file)
    p "You supplied the file: #{file}"
  end
end
