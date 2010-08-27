require 'yaml'

module SunDawg 
  module USAStateTranslater
    # allows client application to override YAML hash
    FILE = File.expand_path(File.join(File.dirname(__FILE__), 'usa_states.yml')) unless defined?(FILE)
    USA_STATES = YAML.load_file(FILE) unless defined?(USA_STATES)

    # O(N) translation from state name to 2-digit code
    def self.translate_name_to_code(name)
      USA_STATES.each_pair do |key, value| 
        return key if value["name"] == name 
      end
      raise NoStateError.new("[#{name}] IS NOT VALID")
    end

    # O(1) translation of 2-digit code to name
    def self.translate_code_to_name(code)
      state = USA_STATES[code]
      raise NoStateError.new("[#{code}] IS NOT VALID") if state.nil?
      state["name"]
    end

    class NoStateError < StandardError
    end
  end
end
