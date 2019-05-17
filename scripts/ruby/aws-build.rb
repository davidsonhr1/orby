require_relative '../require.rb'

printf "ETL-run Jenkins Job \n".yellow

printf "Login (jenkins): "
username = STDIN.gets.chomp
password = STDIN.getpass("Password: ").chomp

@client = JenkinsApi::Client.new(
	:server_ip => '172.17.0.111',
	:username => ENV["JENKINS_USERNAME"],
	:password => ENV["JENKINS_PASSWORD"]
)

printf "\nScript (.yaml): "
script = STDIN.gets.chomp

printf "\nTenant: "
tenant = STDIN.gets.chomp

printf "\nBranch: "
branch = STDIN.gets.chomp

opts = {'Script' => "etl/#{script}", 'BIClient' => tenant, 'Branch' => branch}

@client.job.build('etljob', opts)

printf "#{script} started job\n".light_green