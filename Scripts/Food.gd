extends Sprite2D


signal spawn_food
signal spawn_dust(position: Vector2)
var tween
var fruits: PackedStringArray = ["res://Assets/apple.svg", "res://Assets/lemon.svg", "res://Assets/grapes.svg"]


func _ready() -> void:
	connect("spawn_food", _on_spawn_food)


func _on_spawn_food() -> void:
	$Animation.stop()

	texture = load(fruits[randi_range(0, fruits.size()-1)])
	offset.y = -100.0
	scale = Vector2(2, 2)
	if tween: tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property(self, "offset:y", 0.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector2.ONE, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

	await get_tree().create_timer(0.25).timeout
	$Animation.play("idle")
	spawn_dust.emit(global_position)
