extends Control

@onready var columns: HBoxContainer = $MarginContainer/Columns

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
		for cell in col.get_children():
			cell.gui_input.connect(func(event: InputEvent):
				print("FBHDGFH")
				if event is InputEventMouseButton:
					if event.pressed:
						if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
							print(cell)
							place_piece(col.get_index()))

func col_full(index):
	if columns.get_child(index).get_child(0).name.is_valid_html_color():
		return true
	return false

func place_piece(index: int):
	if col_full(index):
		return
	var cells = columns.get_child(index).get_children()
	for i in range(cells.size() - 1, -1, -1):
		var cell = cells[i]
		print(cell)
		if (not cell.name.is_valid_html_color()) or i > cells.size() - 1:
			set_piece(Vector2i(index, i), Color.RED)
			break


func _on_v_box_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("COL 1 CLICK")
