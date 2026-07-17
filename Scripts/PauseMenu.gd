extends CanvasLayer


signal continue_game
signal mouse_entered
var tween


func _on_continue_button_pressed() -> void:
	continue_game.emit()


func _on_ContinueButton_mouse_entered() -> void:
	mouse_entered.emit()
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property($Screen/ContinueButton, "offset_transform_scale", Vector2(1.2, 1.2), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Screen/ContinueButton, "offset_transform_rotation", -0.05, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Screen/ContinueButton, "self_modulate", Color(1.25, 1.25, 1.25, 1.0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)


func _on_ContinueButton_mouse_exited() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property($Screen/ContinueButton, "offset_transform_scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Screen/ContinueButton, "offset_transform_rotation", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Screen/ContinueButton, "self_modulate", Color(1, 1, 1, 1), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
