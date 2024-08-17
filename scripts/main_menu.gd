extends Control

@export_file("*.tscn") var game_scene: String

func _on_host_pressed() -> void:
	Global.connection_type = Global.Connection.HOST
	transition()


func _on_join_pressed() -> void:
	Global.connection_type = Global.Connection.JOIN
	var decode = Encrypter.decrypt(%JoinCode.text)
	Global.ip = decode.get_slice(":", 0)
	Global.port = int(decode.get_slice(":", 1))
	print(decode)
	transition()


func transition():
	SceneManager.transition_to(game_scene)
