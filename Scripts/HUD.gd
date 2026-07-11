extends CanvasLayer


signal score_update


func _ready() -> void:
	connect("score_update", _on_score_update)


func _on_score_update() -> void:
	var tween: Tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property($ScoreLabel, "offset_transform_scale", Vector2(1.2, 1.2), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($ScoreLabel, "offset_transform_rotation", -0.05, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.chain().tween_property($ScoreLabel, "offset_transform_scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($ScoreLabel, "offset_transform_rotation", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
