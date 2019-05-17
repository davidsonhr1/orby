require_relative '../require.rb'
require_relative '../initialize.rb'
include OrbyInitialize
arg = OrbyInitialize.init

oracle = Sequel.oracle("#{arg[:url]}/#{arg[:url].split('-').first}", :user => arg[:client], :password => arg[:client])

query = arg[:query].gsub('.',' ').gsub('limit', 'where 1=1 and rownum <= ').to_s
p "Query -> #{query}"
rs = oracle[query].each{|r| r.each {|l| printf "#{l.to_s} \n"}; "\n#{100.times{printf "-"}}\n" }