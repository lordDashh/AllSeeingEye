require 'json'

class JsonLoader
  def self.load(path)
    data = IO.read(path)
    JSON.parse(data);
  end

  def self.save(path, data)
    File.open(path, 'w') do |file|
      file.write(JSON.pretty_generate(data))
    end
  end
end
