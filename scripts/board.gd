extends Control

signal placed(pos: Vector2i)
signal played_turn

@onready var columns: HBoxContainer = $MarginContainer/Columns

var playing = true

var turn = 0:
	set(value):
		turn = value
		played_turn.emit()

var player_1_col = Color.RED
var player_2_col = Color.BLUE

var default_colour = Color.WHITE

var assigned_turn = 0

# LEFT, UP, UPLEFT, DOWNLEFT
const DIRECTIONS = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, -1)]

var upnp_thread: Thread
func _upnp_setup(server_port):
	# UPNP queries take some time.
	var upnp = UPNP.new()
	var err = upnp.discover()

	if err != OK:
		push_error(str(err))
		emit_signal("upnp_completed", err)
		return

	if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "UDP")
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "TCP")
		emit_signal("upnp_completed", OK)

func set_code_label():
	var code = ""
	

func _ready() -> void:
	
	var peer = ENetMultiplayerPeer.new()
	match Global.connection_type:

		Global.Connection.JOIN:
			peer.create_client(Global.ip, Global.port)
			assigned_turn = 1

		Global.Connection.HOST:
			upnp_thread = Thread.new()
			upnp_thread.start(_upnp_setup.bind(Global.port))
			
			peer.create_server(Global.port)

	multiplayer.multiplayer_peer = peer
	$ConnectionLabel.text = str(Global.connection_type)
	connect_children()

func connect_children():
	for col in columns.get_children():
		col.gui_input.connect(func(event: InputEvent):
			if event is InputEventMouseButton:
				if event.pressed:
					if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
						if !playing:
							return
						if turn != assigned_turn:
							return
						if col_full(col.get_index()):
							return
						place_piece.rpc(col.get_index()))


func reset():
	playing = true
	turn = 0
	#update_bg_color()

	var panel = columns.get_child(0).get_child(0).get_theme_stylebox("panel")
	panel.bg_color = default_colour
	for col in columns.get_children():
		for cell in col.get_children():
			cell.add_theme_stylebox_override("panel", panel)
			cell.name = "P"



func set_piece(cell_pos: Vector2i, new_colour: Color):
	var col = columns.get_child(cell_pos.x)
	var cell = col.get_child(cell_pos.y)

	var panel = cell.get_theme_stylebox("panel").duplicate()
	panel.bg_color = new_colour
	cell.add_theme_stylebox_override("panel", panel)
	cell.name = str(new_colour.to_html(false) + "C")




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
	if out_of_bounds(pos):
		return

	var col = columns.get_child(pos.x)
	var cell = col.get_child(pos.y)
	return cell

@rpc("any_peer", "call_local", "reliable")
func place_piece(index: int):
	var cells = columns.get_child(index).get_children()
	for i in range(cells.size() - 1, -1, -1):
		var cell = cells[i]

		if !piece_is_placed(cell) or i > cells.size() - 1:
			var piece_col = player_1_col if turn == 0 else player_2_col
			set_piece(Vector2i(index, i), piece_col)
			placed.emit(Vector2i(index, i))
			break

	turn += 1
	turn %= 2

func out_of_bounds(pos: Vector2i) -> bool:
	if columns.get_child_count() < pos.x + 1\
			or columns.get_child(0).get_child_count() < pos.y + 1:
		return true
	return false


func _exit_tree():
	# Wait for thread finish here to handle game exit while the thread is running.
	upnp_thread.wait_to_finish()
