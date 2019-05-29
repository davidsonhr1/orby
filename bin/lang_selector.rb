class LangSelector
	def initialize(lang)
		@lang = lang
	end
	
	def classify_lang
		case @lang
		when 'rb'
			'ruby'
		when 'py'
			'python3'
		when 'sh'
			'sh'
		when 'java'
			'java -jar'
		when 'class'
			'javac'
		when nil
			'ruby'
		when 'ruby'
			'rb'
		when 'python3'
			'py'
		when 'shell'
			'sh'
		when 'java'
			'class'
		when 'python'
			'py'
		end
	end

	def classify_template
		case @lang
		when 'rb'
			'ruby_template'
		when 'py'
			'python_template'
		end
	end
end