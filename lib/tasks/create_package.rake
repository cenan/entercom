desc "Create package for distribution."
task create_package: :environment do
  version = File.read(Rails.root.join "VERSION").strip
  path = "tmp/entcom-#{version}.ecp"

  puts "Creating package..."
  puts `bundle --path vendor/bundle`
  puts `tar -cvzf #{path} --exclude .git --exclude \"log/*.log\" --exclude tmp --exclude .sass-cache .`

  encrypted_package = License.encrypt File.read(path)
  File.open(path, 'w'){|f| f.write encrypted_package}

  puts "Done! Created:\n#{path}"
end
