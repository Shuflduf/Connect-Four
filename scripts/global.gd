extends Node

var connection_type: Connection

var port = 8080
var ip = "localhost"

var local = false

enum Connection {
	HOST,
	JOIN
}
