extends Sprite2D


signal follow_segment(segment: Sprite2D)
signal follow_food(food: Sprite2D)
var snake_segment
var food_spawn
var tween


func _ready() -> void:
	connect("follow_segment", _on_following_segment)
	connect("follow_food", _on_following_food)


func _process(_delta: float) -> void:
	if snake_segment != null:
		position = snake_segment.position


func _on_following_segment(segment: Sprite2D) -> void:
	snake_segment = segment
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property(self, "scale", Vector2.ZERO, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

	await tween.finished
	tween.kill()
	queue_free()


func _on_following_food(food: Sprite2D) -> void:
	food_spawn = food
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

	await tween.finished
	tween.kill()
	queue_free()
