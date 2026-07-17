extends Node


@export var hotspot := Vector2(15, 15)
@onready var arrow = preload("res://Assets/cursor.svg")
@onready var pointer = preload("res://Assets/pointer.svg")


func _ready() -> void:
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, hotspot)
	Input.set_custom_mouse_cursor(pointer, Input.CURSOR_POINTING_HAND, hotspot)
