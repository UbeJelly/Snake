extends Node


@export_category("Sprite2D")
@export var snake_scene: PackedScene = preload("res://Scenes/SnakeSegment.tscn")
@export var dust_scene: PackedScene = preload("res://Scenes/Dust.tscn")
@export var shadow: PackedScene = preload("res://Scenes/Shadow.tscn")

@export_category("Game")
@export var score: int
@export var game_started := false

@export_category("Grid")
@export var cells: int = 15
@export var cell_size: int = 50

# food variables
var food_position: Vector2i
var drop_food := true

# snake_refs variables
var old_data: Array[Vector2i]
var snake_data: Array[Vector2i]
var snake_refs: Array[Sprite2D]
var head: Vector2i

# move variables
var spawn_point := Vector2i(7, 6)
var up := Vector2i.UP
var down := Vector2i.DOWN
var left := Vector2i.LEFT
var right := Vector2i.RIGHT
var move_direction := Vector2i.ZERO
var can_move: bool

@onready var food: Sprite2D = $World/SnakeSegments/Entities/Food
@onready var snake: CanvasGroup = $World/SnakeSegments/Entities/Snake

@onready var sfx: AudioStreamPlayer = $SFX
@onready var eat: AudioStreamWAV = preload("res://Assets/eat.wav")
@onready var hit: AudioStreamWAV = preload("res://Assets/hit.wav")
@onready var drop: AudioStreamWAV = preload("res://Assets/drop.wav")
@onready var focus: AudioStreamWAV = preload("res://Assets/focus.wav")


func _ready() -> void:
	get_tree().get_root().disable_3d = true
	new_game()


func new_game() -> void:
	get_tree().paused = false
	get_tree().call_group("segments", "queue_free")
	get_tree().call_group("shadows", "queue_free")
	get_tree().call_group("dusts", "queue_free")

	$GameOver.hide()
	$Title.show()
	score = 0
	$HUD/ScoreLabel.text = "SCORE: %s" % score
	move_direction = up
	can_move = true

	$Transition.emit_signal("open_transition")
	spawn_snake()
	move_food()


func spawn_snake() -> void:
	old_data.clear()
	snake_data.clear()
	snake_refs.clear()

	for i in range(3): # start at spawn_point, make tail segments
		add_segment(spawn_point + Vector2i(0, i))

	head = snake_data[0]


func add_segment(pos: Vector2i) -> void:
	snake_data.append(pos)
	var snake_segment: Sprite2D = snake_scene.instantiate()
	var snake_shadow: Sprite2D = shadow.instantiate()
	snake_segment.position = (pos * cell_size) + Vector2i(0, cell_size)
	snake_shadow.position = (pos * cell_size) + Vector2i(0, cell_size)
	snake.add_child(snake_segment, true)
	$World/SnakeSegments/Entities.add_child(snake_shadow, true)
	snake_refs.append(snake_segment)
	snake_segment.emit_signal("spawn_segment")
	snake_shadow.emit_signal("follow_segment", snake_segment)


func _process(_delta: float) -> void:
	move_snake()


func move_snake() -> void:
	if can_move:
		if Input.is_action_just_pressed("move_down") and move_direction != up:
			if $Title.has_signal("hide_title"):
				$Title.emit_signal("hide_title")
			move_direction = down
			set_move()
		if Input.is_action_just_pressed("move_up") and move_direction != down:
			if $Title.has_signal("hide_title"):
				$Title.emit_signal("hide_title")
			move_direction = up
			set_move()
		if Input.is_action_just_pressed("move_left") and move_direction != right:
			if $Title.has_signal("hide_title"):
				$Title.emit_signal("hide_title")
			move_direction = left
			set_move()
		if Input.is_action_just_pressed("move_right") and move_direction != left:
			if $Title.has_signal("hide_title"):
				$Title.emit_signal("hide_title")
			move_direction = right
			set_move()


func set_move() -> void:
	can_move = false
	if not game_started:
		start_game()


func start_game() -> void:
	game_started = true
	$MoveTimer.start()


func _on_MoveTimer_timeout() -> void:
	can_move = true
	old_data = Array([], TYPE_VECTOR2I, "", null)  + snake_data # move segment to old pos
	snake_data[0] += move_direction

	for i in range(len(snake_data)):
		if i > 0: # move segments along by 1
			snake_data[i] = old_data[i - 1]
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(snake_refs[i], "position",
		Vector2((snake_data[i] * cell_size) + Vector2i(0, cell_size)), 0.1)

	head = snake_data[0]

	check_out_bounds()
	check_self_eaten()
	check_food_eaten()


func check_out_bounds() -> void:
	if head.x < 0 or head.x > cells - 1 or head.y < 0 or head.y > cells - 1:
		sfx.stream = hit
		sfx.play()
		end_game()


func check_self_eaten() -> void:
	for i in range(1, len(snake_data)):
		if head == snake_data[i]:
			sfx.stream = hit
			sfx.play()
			end_game()


func check_food_eaten() -> void:
	if head == food_position:
		score += 1
		$HUD/ScoreLabel.text = "SCORE: %s" % score
		$HUD.score_update.emit()
		sfx.stream = eat
		sfx.play()
		add_segment(old_data[-1])
		move_food()


func move_food() -> void:
	while drop_food:
		drop_food = false
		food_position = Vector2i(randi_range(0, cells - 1), randi_range(0, cells - 1))
		for i in snake_data:
			if food_position == i:
				drop_food = true
	food.position = (food_position * cell_size) + Vector2i(0, cell_size)
	drop_food = true
	food.emit_signal("spawn_food")
	await food.spawn_food


func end_game() -> void:
	$GameOver.show()
	$MoveTimer.stop()
	game_started = false
	$GameOver.emit_signal("close_transition", snake_refs[0].position)
	$HUD/ScoreLabel.offset_transform_scale = Vector2.ONE
	$HUD/ScoreLabel.offset_transform_rotation = 0.0
	$GameOver/RestartButton.offset_transform_scale = Vector2.ONE
	$GameOver/RestartButton.offset_transform_rotation = 0.0
	$GameOver/RestartButton.self_modulate = Color(1, 1, 1, 1)
	get_tree().paused = true


func _on_game_over_restart() -> void:
	new_game()


func _on_game_over_mouse_entered() -> void:
	sfx.stream = focus
	sfx.play()


func _on_food_spawn_dust(position: Vector2) -> void:
	var dust: GPUParticles2D = dust_scene.instantiate()
	var food_shadow: Sprite2D = shadow.instantiate()
	food_shadow.position = position
	dust.position = position + Vector2(25, 25)
	dust.emitting = true
	$World/SnakeSegments/Entities.add_child(dust, true)
	$World/SnakeSegments/Entities.add_child(food_shadow, true)
	food_shadow.emit_signal("follow_segment", food)
	sfx.stream = drop
	sfx.play()


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint() or OS.is_debug_build():
		if event is InputEventKey and event.physical_keycode == KEY_R and event.pressed:
			can_move = false
			game_started = false
			$MoveTimer.stop()
			new_game()
