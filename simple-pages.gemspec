$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simple-pages/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simple-pages"
  s.version     = SimplePages::VERSION
  s.authors     = ["Mark Asson"]
  s.email       = ["mark@fatdude.net"]
  s.homepage    = "https://github.com/fatdude/simple-pages"
  s.summary     = "Summary of SimplePages."
  s.description = "Description of SimplePages."

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "ancestry"
  s.add_dependency "codemirror-rails"
  s.add_dependency "bootstrap-wysihtml5-rails"
  s.add_development_dependency "sqlite3"
end
