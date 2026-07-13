extends Panel


signal spawn_food
signal spawn_dust(position: Vector2)
var tween


func _ready() -> void:
	connect("spawn_food", _on_spawn_food)


func _on_spawn_food() -> void:
	offset_transform_position.y = -100.0
	$Shadow.offset_transform_position.y = 100.0
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property(self, "offset_transform_position:y", 0.0,
	1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($Shadow, "offset_transform_position:y", 0.0,
	1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	await get_tree().create_timer(0.25).timeout
	spawn_dust.emit(global_position)
