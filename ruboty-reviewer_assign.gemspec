
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruboty/reviewer_assign/version"

Gem::Specification.new do |spec|
  spec.name          = "ruboty-reviewer_assign"
  spec.version       = Ruboty::ReviewerAssign::VERSION
  spec.authors       = ["motsat"]
  spec.email         = ["konpeiex@gmail.com"]

  spec.summary       = %q{ruboty + slackでレビュアーアサイン}
  spec.description   = %q{ruboty + slackでレビュアーアサイン}
  spec.homepage      = "https://github.com/motsat/ruboty-reviewer_assign"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'dotenv'
  spec.add_dependency "ruboty-slack_rtm"
  spec.add_dependency "octokit"
  spec.add_dependency "activesupport"
  spec.add_dependency "redis-objects"
end
