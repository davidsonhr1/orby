require_relative 'lang_selector.rb'

class FileCreator
	def initialize(filename, extension, path)
		@filename = filename
		@extension = extension
		@path = path
		p @path
	end
	
	def create_file
		f = File.open("#{@path}#{@filename}.#{@extension}", 'w+')
		selector = LangSelector.new(@extension)
		template = selector.classify_template
		f.write("#{eval(template)}")
		f.close
	end

	private
	def ruby_template
		template = <<-EOF
		require_relative '../../require.rb'
		require_relative '../../initialize.rb'
		include OrbyInitialize
		arg = OrbyInitialize.init

		class #{@filename.capitalize}

			def init
			end

		end

		#{@filename.capitalize}.init
		EOF
		return template.gsub('		','')
	end

	def python_template
		template = <<-EOF
		import sys
		from os import path
		sys.path.append(path.join(path.dirname(__file__), '../../bin/'))
		from pycore import get_options

		def init():
			print('Init Script')
		init()	
		EOF
		return template.gsub('		','')
	end
end