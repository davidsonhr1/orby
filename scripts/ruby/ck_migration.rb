require_relative '../require.rb'
require_relative '../initialize.rb'
include OrbyInitialize
arg = OrbyInitialize.init

oracle = Sequel.oracle("#{arg[:url]}/#{arg[:url].split('-').first}", :user => arg[:client], :password => arg[:client])

begin
	table = oracle['dual']
	if table then printf "Database is online \n".light_green end
rescue Sequel::Error
	printf "Database is offline \n #{$!.message}".light_red
end