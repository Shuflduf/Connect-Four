extends Node

var connection_type: Connection

var port = 8080
var ip = "localhost"

enum Connection {
	HOST,
	JOIN
}

func _ready() -> void:
	if OS.has_feature("windows"):
		if OS.has_environment("COMPUTERNAME"):
			ip =  IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	elif OS.has_feature("linux"):
		if OS.has_environment("HOSTNAME"):
			ip =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	elif OS.has_feature("OSX"):
		if OS.has_environment("HOSTNAME"):
			ip =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	
	print(ip)
