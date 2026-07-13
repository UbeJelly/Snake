extends Panel


signal spawn_segment
var tween


func _ready() -> void:
	connect("spawn_segment", _on_spawn_segment)


func _on_spawn_segment() -> void:
	offset_transform_position.y = -100.0
	$Shadow.offset_transform_position.y = 100.0
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property(self, "offset_transform_position:y", 0.0,
	1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($Shadow, "offset_transform_position:y", 0.0,
	1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

	await tween.finished
	$Shadow.queue_free()
	tween.kill()
