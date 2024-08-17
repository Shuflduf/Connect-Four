extends Control

@export_file("*.tscn") var game_scene: String

func _on_host_pressed() -> void:
	Global.connection_type = Global.Connection.HOST
	Global.port = $VBoxContainer/HBoxContainer/JoinCode.value
	transition()


func _on_join_pressed() -> void:
	Global.connection_type = Global.Connection.JOIN
	if !%Local.button_pressed:
		var decode = Encrypter.decrypt(%JoinCode.text)
		Global.ip = decode.get_slice(":", 0)
		Global.port = int(decode.get_slice(":", 1))
	transition()


func transition():
	Global.local = %Local.button_pressed
	SceneManager.transition_to(game_scene)
