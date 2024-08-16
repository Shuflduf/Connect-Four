extends Control

@onready var columns: HBoxContainer = $MarginContainer/Columns

var turn = 0

var player_1_col = Color.RED
var player_2_col = Color.BLUE

# LEFT, UP, UPLEFT, DOWNLEFT
const DIRECTIONS = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, -1)]

func set_piece(cell_pos: Vector2i, new_colour: Color):
	var col = columns.get_child(cell_pos.x)
	var cell = col.get_child(cell_pos.y)

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

	if !piece.name.get_slice("C", 0).is_valid_html_color():
		return -1

	var colour: Color

	colour = Color(piece.name.get_slice("C", 0))

	match colour:
		player_1_col:
			return 0
		player_2_col:
			return 1
	return -1


func get_panel(pos: Vector2i) -> Panel:

	if columns.get_child_count() < pos.x + 1\
			or columns.get_child(0).get_child_count() < pos.y + 1:
		print("DKHKJGNDUM")

	var col = columns.get_child(pos.x)
	var cell = col.get_child(pos.y)
	return cell


func place_piece(index: int):
	var cells = columns.get_child(index).get_children()
	for i in range(cells.size() - 1, -1, -1):
		var cell = cells[i]

		if !piece_is_placed(cell) or i > cells.size() - 1:
			var piece_col = player_1_col if turn == 0 else player_2_col
			set_piece(Vector2i(index, i), piece_col)
			check_win(Vector2(index, i))
			break

	turn += 1
	turn %= 2


func check_win(input: Vector2i) -> bool:
	var player = get_player(get_panel(input))
	var first_piece = input



	var won = true

	for dir in DIRECTIONS:
		while !out_of_bounds(first_piece - dir):

			first_piece.x -= 1


		for i in 4:

			var new_pos = first_piece
			print(dir * i)
			new_pos += dir * i
			if new_pos.x > columns.get_child_count() - 1 \
					or new_pos.y > columns.get_child(0).get_child_count() - 1:
				won = false
				break
			if get_player(get_panel(new_pos)) != player:
				won = false

		if won:
			print("AJHBFGNDm")

	return won


func out_of_bounds(pos: Vector2i) -> bool:
	if columns.get_child_count() < pos.x + 1\
			or columns.get_child(0).get_child_count() < pos.y + 1:
		return true
	return false
