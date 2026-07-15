extends CanvasLayer


var tween


func _ready() -> void:
	jump_up()


func jump_up() -> void:
	if visible == true:
		$Icon.offset_transform_scale = Vector2.ONE
		$Icon.offset_transform_position.y = 0.0
		tween = get_tree().create_tween().set_parallel(true).bind_node(self)
		tween.tween_property($Icon, "offset_transform_scale", Vector2(0.9, 1.25), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($Icon, "offset_transform_position:y", -100, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		await tween.finished
		bounce()
	else: if tween: tween.kill()


func bounce() -> void:
	if visible == true:
		tween = get_tree().create_tween().set_parallel(true).bind_node(self)
		tween.tween_property($Icon, "offset_transform_scale", Vector2.ONE, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property($Icon, "offset_transform_position:y", 0.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		await tween.finished
		jump_up()
	else: if tween: tween.kill()


func _on_visibility_changed() -> void:
	if visible == true:
		jump_up()
