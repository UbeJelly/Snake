extends CanvasLayer


signal restart
signal close_transition
var tween_button
var tween_transition


func _ready() -> void:
	connect("close_transition", _on_close_transition)


func _on_RestartButton_pressed() -> void:
	restart.emit()


func _on_RestartButton_mouse_entered(button: Button) -> void:
	if tween_button: tween_button.kill()
	tween_button = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween_button.tween_property(button, "offset_transform_scale", Vector2(1.2, 1.2), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_button.tween_property(button, "offset_transform_rotation", -0.05, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_button.tween_property(button, "self_modulate", Color(1.25, 1.25, 1.25, 1.0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)


func _on_RestartButton_mouse_exited(button: Button) -> void:
	if tween_button: tween_button.kill()
	tween_button = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween_button.tween_property(button, "offset_transform_scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_button.tween_property(button, "offset_transform_rotation", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_button.tween_property(button, "self_modulate", Color(1, 1, 1, 1), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)


func _on_close_transition(snake_head: Vector2) -> void:
	$GameOverTransition.get_material().set_shader_parameter("progress", 0.0)
	$GameOverTransition.get_material().set_shader_parameter("circle_position",
	(snake_head + Vector2(25, 25)) / Vector2(owner.get_window().size))
	if tween_transition: tween_transition.kill()
	tween_transition = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween_transition.tween_method(set_shader_value, 0.75, 1.0, 0.75).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)


func set_shader_value(value: float) -> void:
	$GameOverTransition.get_material().set_shader_parameter("progress", value)
