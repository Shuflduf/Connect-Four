extends Control

@onready var columns: HBoxContainer = $MarginContainer/Columns

var player_1_turn = true

func set_piece(cell_pos: Vector2i, new_colour: Color):
	var col = columns.get_child(cell_pos.x)
	var cell = col.get_child(cell_pos.y)
	#(cell, Color.RED)

	var panel = cell.get_theme_stylebox("panel").duplicate()
	panel.bg_color = new_colour
	cell.add_theme_stylebox_override("panel", panel)
	cell.name = str(new_colour.to_html(false))


#func change_color(cell: Panel, new_colour: Color):


func _ready() -> void:
	for col in columns.get_children():
		col.gui_input.connect(func(event: InputEvent):
			print("FBHDGFH")
			if event is InputEventMouseButton:
				if event.pressed:
					if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
						if col_full(col.get_index()):
							return
						place_piece(col.get_index()))

func col_full(index):
	if piece_placed(columns.get_child(index).get_child(0)):
		return true
	return false

func piece_placed(piece: Panel) -> bool:
	var is_color = false
	if piece.name.is_valid_html_color():
		is_color = true
	elif piece.name.length() > 6:
		if piece.name.erase(6, 1).is_valid_html_color():
			is_color = true
	return is_color


func place_piece(index: int):
	player_1_turn = !player_1_turn
	var cells = columns.get_child(index).get_children()
	for i in range(cells.size() - 1, -1, -1):
		var cell = cells[i]
		print(cell)
		
		if !piece_placed(cell) or i > cells.size() - 1:
			var piece_col = Color.RED if player_1_turn else Color.BLUE
			set_piece(Vector2i(index, i), piece_col)
			break


func _on_v_box_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("COL 1 CLICK")
