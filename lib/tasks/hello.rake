class Hello
  def self.hello
    puts 'hello'
  end
end

desc "Print hello"
task :hello do
  Hello.hello
end
