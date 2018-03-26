require 'nokogiri'
require 'optparse'
require 'json'
require 'find'

def start
	@document = Nokogiri::XML(File.open("emails.xml"))
	@records  = []
	xml_extractor
	puts "Commands:"
	puts "s3455658_p2.rb -xml [FILENAME]					# Load a XML file"
	puts "s3455658_p2.rb help [COMMAND]					# Describe available commands or one specific command"
	options
end

#rewrite
def options
	if ARGV[0] .eql? '-xml'
		filename = ARGV[1]
		xml_parser(filename)
	elsif ARGV[0] .eql? 'help'
		if ARGV[1] .eql? nil
			puts "List of available commands:"
			puts "-xml: This command loads a xml file."
			puts "help: This command describes and lists available commands"
			puts "List: This command lists the extracted xml records"
			puts "List --ip: This command is an extension of 'List' that searches and lists a record by ip address"
			puts "List --name: This command is an extension of 'List' that searches and lists a record by name"
		else
			command = ARGV[1]
			help_commands(command)
		end
	elsif ARGV[0] .eql? 'List'
		if ARGV[1] .eql? nil
			list_records
		elsif ARGV[1] .eql? '--ip'
			ip_address = ARGV[2]
			ip_print = search_by_ip(ip_address)
			puts JSON.pretty_generate(ip_print)
		elsif ARGV[1] .eql? '--name'
			person_name = ARGV[2]
			name_print = search_by_name(person_name)
			puts JSON.pretty_generate(name_print)
		else
			puts "The inputted command is not an valid extension of 'List'"
		end
	else
		puts "The inputted command does not exist!"
	end
end
#finish

def help_commands(command)
	case command
		when 'xml'
			puts "xml: This command loads a xml file"
		when "help"
			puts "help: This command describes and lists available commands"
		when "List"
			puts "List: This command lists the extracted xml records"
		when "List --ip"
			puts "List --ip: This command is an extension of 'List' that searches and lists a record by ip address"
		when "List --name"
			puts "List --name: This command is an extension of 'List' that searches and lists a record by name"
		else
			puts "The command you are searching for does not exist!"
	end
end

def xml_parser(filename)
	document = Nokogiri::XML(File.open("#{filename}"))
	puts document
end

#rewrite
def xml_extractor
	@document.xpath("//record").each do |record|
      	@records << {:id => record.xpath('id').text,
		:first_name => record.xpath('first_name').text,
		:last_name => record.xpath('last_name').text,
		:email => record.xpath('email').text,
		:gender => record.xpath('gender').text,
		:ip_address => record.xpath('ip_address').text,
		:send_date => record.xpath('send_date').text,
		:email_body => record.xpath('email_body').text,
		:email_title => record.xpath('email_title').text}
 	end
	self
 end
#finish
 
def list_records
	@records.each do |k,v|
		puts k,v
	end
end

def search_by_ip(ip)
	@records.select {|k| k[:ip_address] == ip.to_s}.first
end

def search_by_name(n)
	@records.select {|k| k[:first_name] == n.to_s}.first
end




start
