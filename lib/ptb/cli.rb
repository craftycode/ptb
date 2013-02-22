module Ptb
  class CLI < Thor
    def initialize(*)
      super

      Signal.trap("SIGINT") do
        exit!
      end
    end

    default_task :branch

    desc "branch", "List git branches with related PivotalTracker story information."
    def branch
      branches=`git branch`

      branches.each_line do |line|
        branch = line[2..-2]
        if branch =~ /^[0-9]+$/
          if story = project.stories.find(branch)
            say "#{line.rstrip} [#{story.current_state}] #{story.name} (#{story.url})"
          else
            say line.rstrip
          end
        else
          say line.rstrip
        end
      end
    end

    private

    def choose(prompt, choices, confirm=false)
      selection = nil
      say ""
      choices.each_with_index do |option, index|
        say "#{index}) #{option[0]}"
      end
      until selection do
        say ""
        selection_index = ask(prompt)
        selection       = choices[selection_index.to_i]
        if selection and confirm
          say ""
          selection = nil unless yes?("#{selection[0]}? (yn):")
        end
      end
      say ""
      return selection[1]
    end

    # PivotalTracker::Client.token='3bf308bd729d2d87637a157bc6d2830d'
    def project
      return @project if @project

      if File.exists?(".ptbrc")
        config = YAML.load(File.read(".ptbrc"))
        PivotalTracker::Client.token=config['token']
        @project = PivotalTracker::Project.find(config['project'])
      else
        config = {}
        PivotalTracker::Client.token = config['token'] = ask("Enter your PivotalTracker API token:")
        @project = choose("Select a project:", PivotalTracker::Project.all.map{|p| [p.name, p]})
        config['project'] = @project.id
        File.open('.ptbrc', 'w') do |file|
          file.write(config.to_yaml)
        end
      end

      @project

    rescue
      exit
    end

  end
end
