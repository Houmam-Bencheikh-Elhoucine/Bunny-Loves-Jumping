extends Node2D

@export var max_spawn = 100
@export_range(0, 1) var spawn_probability:float = 0.25

@export var enemies:Array[PackedScene] = [preload("res://Game Objects/flyman.tscn")]

@export var min_height = 0
@export_range(0, INF) var limit = 1000
@export_range (0, 5) var max_wingmen = 5

@onready var player = get_tree().root.get_node("Level").get_node_or_null("Player")
var spawned = 0
var wingmen = 0

func _process(_delta) -> void:
	if spawned >= max_spawn or randf() > spawn_probability:
		return 
	var e = enemies.pick_random().instantiate()
	e.position.x = randi_range(0, 1440)
	e.position.y = randi_range(min_height-limit, min_height)
	e.connect("removed", removed_enemy)
	if e.has_signal("removed_wingman"):
		if wingmen < max_wingmen:
			e.connect("removed_wingman", remove_wingman)
			wingmen += 1
		else:return
	e.player = player
	add_child(e)
	min_height = e.position.y
	spawned += 1

func removed_enemy():
	spawned -= 1

func remove_wingman():
	wingmen -= 1
