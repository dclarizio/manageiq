$:.push("#{File.dirname(__FILE__)}/..")

require 'rubygems'
require 'log4r'
require "NmaClient"
require "../../util/MiqDumpObj"

class ConsoleFormatter < Log4r::Formatter
	def format(event)
		"**** " + (event.data.kind_of?(String) ? event.data : event.data.inspect) + "\n"
	end
end
$vim_log = Log4r::Logger.new 'toplog'
Log4r::StderrOutputter.new('err_console', :level=>Log4r::INFO, :formatter=>ConsoleFormatter)
$vim_log.add 'err_console'

class Dump
	include MiqDumpObj
end

begin
	
	dump = Dump.new
	
	NmaClient.logger	= $vim_log
	NmaClient.wire_dump	= false
	
	nma = NmaClient.new {
		server		SERVER
		auth_style	NmaClient::NA_STYLE_LOGIN_PASSWORD
		username	USERNAME
		password	PASSWORD
	}
	
	# NmaCore.server_set_debugstyle(nma.svrObj, NmaCore::NA_PRINT_DONT_PARSE)
	
	rv = nma.lun_list_info
	dump.dumpObj(rv)
	puts
	
	rv = nma.lun_map_list_info(:path, '/vol/luns/lun1')
	dump.dumpObj(rv)
	puts
	
	rv = nma.iscsi_adapter_initiators_list_info
	dump.dumpObj(rv)
	puts
	
	rv = nma.iscsi_connection_list_info
	dump.dumpObj(rv)
	puts
	
rescue => err
	puts err.to_s
	puts err.backtrace.join("\n")
end
