extends CanvasLayer


signal score_update


func _on_score_update() -> void:
	var tween_scale: Tween = get_tree().create_tween().bind_node(self)
	var tween_angle: Tween = get_tree().create_tween().bind_node(self)
	#var tween_color: Tween = get_tree().create_tween().bind_node(self)
	tween_scale.tween_property($ScoreLabel, "offset_transform_scale", Vector2(1.2, 1.2),
	0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_scale.tween_property($ScoreLabel, "offset_transform_scale", Vector2.ONE,
	0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_angle.tween_property($ScoreLabel, "offset_transform_rotation", -0.05,
	0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_angle.tween_property($ScoreLabel, "offset_transform_rotation", 0.0,
	0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	#tween_color.tween_property($ScoreLabel, "self_modulate", Color(1.25, 1.25, 1.25, 1.0),
	#1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
