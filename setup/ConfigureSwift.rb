module Pod

  class ConfigureSwift
    attr_reader :configurator

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @configurator = options.fetch(:configurator)
    end

    def perform
      keep_demo = configurator.ask_with_answers("Would you like to include a demo application with your library", ["Yes", "No"]).to_sym

      Pod::ProjectManipulator.new({
        :configurator => @configurator,
        :xcodeproj_path => "#{configurator.pod_name}/templates/swift/Example/PROJECT.xcodeproj",
        :platform => :ios,
        :remove_demo_project => (keep_demo == :no),
        :prefix => ""
      }).run

      # There has to be a single file in the Classes dir
      # or a framework won't be created
      `touch ./#{configurator.pod_name}/Pod/Classes/ReplaceMe.swift`

      `mv ./#{configurator.pod_name}/templates/swift/* ./#{configurator.pod_name}/`

      # remove podspec for osx
      `rm ./#{configurator.pod_name}/NAME-osx.podspec`
    end
  end

end
