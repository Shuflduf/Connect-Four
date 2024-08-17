class_name WinDetect
extends Node

var parent: Node:
	get:
		return get_parent()


func _ready() -> void:
	parent.placed.connect(check_win)


func check_win(input: Vector2i) -> bool:
	for dir in parent.DIRECTIONS:
		var first_piece = get_start(input, dir)


		if four_in_row(first_piece, dir):
			print("WIN !!")
			%WinLabel.show()
			%WinLabel.text = "Player " + str(get_parent().turn + 1) + " Wins!"
			parent.playing = false
			await get_tree().create_timer(1.5).timeout
			%WinLabel.hide()
			parent.reset()



			break

	return false

func get_start(input: Vector2i, dir: Vector2i) -> Vector2i:
	var player = parent.get_player(parent.get_panel(input))
	var first = input
	while !parent.out_of_bounds(first - dir):
		if parent.get_player(parent.get_panel(first - dir)) != player:
			break
		first -= dir

	return first


func four_in_row(start: Vector2i, dir: Vector2i) -> bool:
	var player = parent.get_player(parent.get_panel(start))
	for i in 4:
		var new_pos = start
		new_pos += dir * i
		if parent.out_of_bounds(new_pos):
			return false
		if parent.get_player(parent.get_panel(new_pos)) != player:
			return false
	return true
