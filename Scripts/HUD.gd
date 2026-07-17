extends CanvasLayer


signal score_update
signal pause_game
var tween


func _ready() -> void:
	connect("score_update", _on_score_update)


func _on_score_update() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property($ScoreLabel, "offset_transform_scale", Vector2(1.3, 1.3), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($ScoreLabel, "offset_transform_rotation", -0.05, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.chain().tween_property($ScoreLabel, "offset_transform_scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($ScoreLabel, "offset_transform_rotation", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)


func _on_pause_button_pressed() -> void:
	pause_game.emit()


func _on_pause_button_mouse_entered() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	$PauseButton.offset_transform_scale = Vector2.ONE
	tween.tween_property($PauseButton, "offset_transform_scale", Vector2(1.25, 1.25), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)


func _on_pause_button_mouse_exited() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	$PauseButton.offset_transform_scale = Vector2(1.25, 1.25)
	tween.tween_property($PauseButton, "offset_transform_scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
