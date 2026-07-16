extends GPUParticles2D


var tween


func _ready() -> void:
	animate()


func animate() -> void:
	await get_tree().create_timer(0.8).timeout
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

	await tween.finished
	tween.kill()


func _on_finished() -> void:
	self.queue_free()
