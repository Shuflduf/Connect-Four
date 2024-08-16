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
	place_piece(1)
	place_piece(1)

func place_piece(index: int):
	var cells = columns.get_child(index).get_children()
	#cells.reverse()
	#var placed = false

	for i in range(cells.size() - 1, -1, -1):
		var cell = cells[i]
		print(cell)
		if (not cell.name.is_valid_html_color()) or i > cells.size() - 1:
			#print(cell.name.is_valid_html_color())
			#print(i > columns.get_child_count() - 3)
			set_piece(Vector2i(index, i), Color.RED)
			#placed = true
			break
