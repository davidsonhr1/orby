module OrbyInitialize
	PARAMETERS_FILE = YAML.load_file("#{__dir__}/config/parameters.yaml")

	def init
		params = PARAMETERS_FILE["params"]

		$arg = Optimist::options do
			opt :script, "script name", :type => "string", :short => "-s"
			params.each {|i| opt i['name'].to_sym, "#{i['description']}", :type => i['type'], :short => "#{i['opt']}"}
		end
	end

end