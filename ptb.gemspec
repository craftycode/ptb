Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "ptb"
  s.version     = "0.0.1"
  s.authors     = ["Anthony Crumley"]
  s.email       = ["anthony.crumley@gmail.com"]
  s.homepage    = "http://craftyco.de"
  s.summary     = %q{A mash up of PivotalTracker and git that makes a one to one story to branch mapping a lot of fun.}
  s.description = %q{A mash up of PivotalTracker and git that makes a one to one story to branch mapping a lot of fun.  It also works nicely with the pt PivotalTracker commandline gem.  When branches are named by the PivotalTracker story id ptb will will do a git branch and list each story id branch with status, title and link to the story.}

  s.rubyforge_project = "ptb"

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "pivotal-tracker"
  s.add_runtime_dependency "thor"
end
