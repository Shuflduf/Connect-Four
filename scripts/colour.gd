extends Panel

var parent: Node:
	get:
		return get_parent()

func _ready() -> void:
	parent.played_turn.connect(update_bg_color)

func update_bg_color():
	var new_col: Color
	match parent.turn:
		0:
			new_col = parent.player_1_col
		1:
			new_col = parent.player_2_col
	var tween = get_tree().create_tween()\
			.set_trans(Tween.TRANS_CIRC)\
			.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", new_col, 0.3)
