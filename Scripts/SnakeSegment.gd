extends Sprite2D


signal spawn_segment
var tween


func _ready() -> void:
	connect("spawn_segment", _on_spawn_segment)


func _on_spawn_segment() -> void:
	z_index = 4
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	offset.y = -100.0
	scale = Vector2(2, 2)
	self_modulate = Color(18.892, 18.892, 18.892, 1.0)
	tween.tween_property(self, "offset:y", 0.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector2.ONE, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 1), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	tween.kill()
	z_index = 1
