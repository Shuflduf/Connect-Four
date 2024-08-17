extends Node

var connection_type: Connection

var port = 8080
var ip = "localhost"

enum Connection {
	HOST,
	JOIN
}

func _ready() -> void:
	#print(UPNP.new().query_external_address())
	
	print(ip)
