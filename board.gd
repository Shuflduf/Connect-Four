extends Control

@onready var rows: VBoxContainer = $MarginContainer/Rows

func set_piece(cell_pos: Vector2i):
	var row = rows.get_child(cell_pos.y)
	var cell = row.get_child(cell_pos.x)
	change_color(cell, Color.RED)

func change_color(cell: Panel, new_colour: Color):
	var panel = cell.get_theme_stylebox("panel").duplicate()
	panel.bg_color = new_colour
	cell.add_theme_stylebox_override("panel", panel)

func _ready() -> void:
	set_piece(Vector2i(2, 3))
