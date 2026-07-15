extends Panel


signal follow_segment(segment: Panel)
var snake_segment
var tween


func _ready() -> void:
	connect("follow_segment", _on_following_segment)


func _process(_delta: float) -> void:
	if snake_segment != null:
		position = snake_segment.position


func _on_following_segment(segment: Panel) -> void:
	snake_segment = segment
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	offset_transform_position.y = 50.0
	tween.tween_property(self, "offset_transform_position:y", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

	await tween.finished
	tween.kill()
	queue_free()
