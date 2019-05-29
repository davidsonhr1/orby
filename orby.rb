require_relative 'require.rb'
require_relative 'bin/lang_selector.rb'
require_relative 'bin/file_creator.rb'
system("sh #{__dir__}/config/config.sh")

module Orby
	SCRIPT_FOLDER = "#{__dir__}/scripts/"
	PARAMETERS_FILE = YAML.load_file("#{__dir__}/config/parameters.yaml")
	
	def self.init
		params = PARAMETERS_FILE["params"]

		$arg = Optimist::options do
			opt :script, "script name", :type => "string", :short => "-s", :default => "hello"
			params.each {|i| opt i['name'].to_sym, "#{i['description']}", :type => i['type'], :short => !i['opt'].nil? ? ("#{i['opt']}") : (nil) }
		end
	end

	def self.verify_command(commands)
		striped, command = [], String.new
		commands.each {|stpd| spt = stpd.split(';')[1];  if spt.split(' ').length == 2 then command.concat(spt) end }
		return command.to_s
	end

	def self.run_script(arg)
		if arg[:script].nil?
			raise "parameter --script or -s can not empty"
		else
			commands = []
			script = arg[:script]
			file = script.split('.')[0]
			file_extension = script.split('.')[1] == nil ? ('rb') : (script.split('.')[1])
			selector = LangSelector.new(file_extension)
			language_prefix = selector.classify_lang
			script_line = "#{language_prefix} #{SCRIPT_FOLDER}#{language_prefix}/#{file}.#{file_extension}"
			arg.each {|index, value| commands << "; --#{index} #{value}"}
			script_line.concat(verify_command(commands))
			exec(script_line.partition("--help").first)
		end
	end

	def self.scaffolding_lang(lang)
		selector = LangSelector.new(lang)
		language_sufix = selector.classify_lang
		creator = FileCreator.new("#{ARGV[2]}", language_sufix, "#{SCRIPT_FOLDER}#{lang}/")
		creator.create_file
		printf "Use: orby -s #{ARGV[2]}.#{language_sufix} to execute you new script \n".light_green
	end

	def self.select_option(initial_arg)
		if initial_arg == 'scaffold'
			lang = ARGV[1]
			Orby.scaffolding_lang(lang)
		elsif initial_arg == '-ls'
			dir = Dir.entries("#{__dir__}/scripts")
			dir = Dir.glob("#{__dir__}/scripts/**/*")
			dir.each {|d| printf "#{d.gsub("#{__dir__}/scripts/",'')} \n".light_yellow}
		elsif initial_arg == '-s'
			Orby.run_script(Orby.init)
		end
	end
end

Orby.select_option(ARGV[0])


