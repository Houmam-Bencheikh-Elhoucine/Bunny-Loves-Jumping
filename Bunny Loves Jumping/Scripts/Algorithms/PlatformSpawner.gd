extends Node2D

@export var max_height = 0
@export var max_spawn = 50
@export var same_spawn = 5

@export var platforms:Array[PackedScene] = [preload("res://Game Objects/platform.tscn")]
@onready var camera = get_tree().root.get_node("Level").get_node_or_null("Player/Camera2D")

@onready var spawned = get_child_count()

var last_spawn_position = Vector2.ZERO
var last_spawn_length = 0

var score = 0

func _process(delta: float) -> void:
	randomize()
	if spawned >= max_spawn:return
	var p1 = platforms.pick_random().instantiate()
	add_child(p1)
	p1.position.y = max_height - randi_range(200, 400)
	p1.position.x = randi_range(last_spawn_position.x-last_spawn_length * 3, last_spawn_position.x+last_spawn_length * 3)
	p1.position.x = clamp(p1.position.x, p1.length/2, 1440-p1.length/2)
	p1.camera = camera
	p1.connect("removed", removed_platform)

	if randi_range(0, 1) == 1:
		p1.position.x = clamp(p1.position.x, p1.length/2, 720-p1.length/2)
		var p2 = platforms.pick_random().instantiate()
		add_child(p2)
		p2.position.y = max_height - randi_range(200, 400)
		p2.position.x = randi_range(last_spawn_position.x-last_spawn_length * 3, last_spawn_position.x+last_spawn_length * 3)
		p2.position.x = clamp(p2.position.x, 720+p2.length/2, 1440-p2.length/2)
		p2.camera = camera
		p2.connect("removed", removed_platform)
		max_height = min(p1.position.y, p2.position.y)
		spawned += 2
		last_spawn_position = (p1.global_position + p2.global_position)/2
		last_spawn_length = max(p1.length, p2.length)
	else:
		max_height = p1.position.y
		spawned += 1
		last_spawn_position = p1.global_position
		last_spawn_length = p1.length

func _ready():
	for i in get_children():
		i.camera = camera

func removed_platform():
	spawned -= 1
	score += 1
