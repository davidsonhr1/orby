require_relative '../require.rb'
require_relative '../initialize.rb'
include OrbyInitialize
arg = OrbyInitialize.init

class Dash
	TABLEAU_PATH = ENV["TABLEAU_PATH"]
	TABLEAU_PASSWORD = ENV["TABLEAU_PASSWORD"]

	def self.read_xml(file)
		begin
			Nokogiri::XML(File.open("#{TABLEAU_PATH}/#{file}"))
		rescue Errno::ENOENT => e
			puts "File or directory #{TABLEAU_PATH}/#{file} doesn't exist."
			exit
		rescue Errno::EACCES => e
			puts "Can't read from #{file}. No permission."
			exit
		end
	end

	def self.check(param)
		!param.nil? ? (param) : (raise "Verifique os parametros necessarios")
	end

	def self.change_connection_params(doc)
		#connection_path = doc.xpath("//connection/named-connections/named-connection/connection[@class='redshift']")
	end

	def self.run(dashboard_file, server, client)
		doc = read_xml("#{dashboard_file}.twb")
		check(server)
		check(client)

		connection_path = doc.xpath("//repository-location")

		connection_path.each do |dt|
			path = dt.xpath("//datasources/datasource/connection/named-connections/named-connection/connection[@class='redshift']")
			
			printf "Criando arquivo tmp_#{dashboard_file}.twb \n".yellow
			printf "#{dashboard_file} - Alterando server para #{server} \n".yellow
			printf "#{dashboard_file} - Alterando cliente e username para #{client} \n".yellow
			
			path.each do |pt|
				pt.attributes["server"].value = server
				pt.attributes["dbname"].value = client
				pt.attributes["username"].value = client
				pt.set_attribute('password', TABLEAU_PASSWORD)
			end
		end
		
		out_file = File.new("tmp_#{dashboard_file}.twb", "w")
		out_file.puts(doc)
		out_file.close
	end
end

Dash.run(arg[:dashboard], arg[:host], arg[:client])


