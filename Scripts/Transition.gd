extends CanvasLayer


signal open_transition
signal exit_transition
var tween


func _ready() -> void:
	connect("open_transition", _on_open_transition)
	connect("exit_transition", _on_exit_transition)


func _on_open_transition() -> void:
	$Panel.get_material().set_shader_parameter("progress", 1.0)
	show()
	if tween: tween.kill()
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_method(set_shader_value, 1.0, 0.0, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	hide()


func _on_exit_transition() -> void:
	$Panel.get_material().set_shader_parameter("progress", 0.0)
	show()
	if tween: tween.kill()
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_method(set_shader_value, 0.25, 1.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)


func set_shader_value(value: float) -> void:
	$Panel.get_material().set_shader_parameter("progress", value)
