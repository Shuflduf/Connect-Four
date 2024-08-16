extends Control

@onready var columns: HBoxContainer = $MarginContainer/Columns

var player_1_turn = true
var turn = 0

var player_1_col = Color.RED
var player_2_col = Color.BLUE

func set_piece(cell_pos: Vector2i, new_colour: Color):
	var col = columns.get_child(cell_pos.x)
	var cell = col.get_child(cell_pos.y)
	#(cell, Color.RED)

	var panel = cell.get_theme_stylebox("panel").duplicate()
	panel.bg_color = new_colour
	cell.add_theme_stylebox_override("panel", panel)
	cell.name = str(new_colour.to_html(false) + "C")


func _ready() -> void:
	for col in columns.get_children():
		col.gui_input.connect(func(event: InputEvent):
			if event is InputEventMouseButton:
				if event.pressed:
					if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
						if col_full(col.get_index()):
							return
						place_piece(col.get_index()))




func col_full(index):
	if piece_is_placed(columns.get_child(index).get_child(0)):
		return true
	return false

func piece_is_placed(piece: Panel) -> bool:
	var is_color = false
	if piece.name.get_slice("C", 0).is_valid_html_color():
		is_color = true
	return is_color

func get_player(piece: Panel) -> int:
	var colour: Color

	colour = Color(piece.name.get_slice("C", 0))

	match colour:
		player_1_col:
			return 0
		player_2_col:
			return 1
	return -1


func get_panel(pos: Vector2i) -> Panel:
	var col = columns.get_child(pos.x)
	var cell = col.get_child(pos.y)
	return cell


func place_piece(index: int):
	var cells = columns.get_child(index).get_children()
	for i in range(cells.size() - 1, -1, -1):
		var cell = cells[i]

		if !piece_is_placed(cell) or i > cells.size() - 1:
			var piece_col = player_1_col if player_1_turn else player_2_col
			set_piece(Vector2i(index, i), piece_col)
			win_horizontally(Vector2(index, i))
			break
	player_1_turn = !player_1_turn
	turn = int(player_1_turn)


func win_horizontally(input: Vector2i) -> bool:
	var player = get_player(get_panel(input))
	var first_piece = input
	while get_player(get_panel(first_piece)) != player:
		first_piece.x -= 1
	print(first_piece)
	return false
