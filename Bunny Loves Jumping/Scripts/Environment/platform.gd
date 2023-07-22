extends StaticBody2D

signal removed
@export var dec: Array[CompressedTexture2D] = []
@export var trampoline = preload("res://Game Objects/trampoline.tscn")
@export var probability = 0.5

var camera = null

@onready var length = round($Sprite2D.get_rect().size.x * $Sprite2D.scale.x)
@onready var collectibles:Array[PackedScene] = [preload("res://Game Objects/carrot.tscn"), preload("res://Game Objects/coin.tscn")]

func _ready():
	#add decorations
	for i in range(randi_range(1, 3)):
		if randf()<probability:
			var s = Sprite2D.new()
			s.texture = dec.pick_random()
			var rect = s.get_rect()
			s.scale.x = randf_range(.75, 1.0)
			s.scale.y = s.scale.x
			s.rotation_degrees = randf_range(-10, 10)
			s.z_index = -1
			s.position.x = randi_range(-length/2+rect.size.x, length/2-rect.size.x)
			s.position.y = -rect.size.y * s.scale.x/2 - randf_range(0, 50)
			add_child(s)
	if randi_range(0, 1):
		var c = collectibles.pick_random().instantiate()
		c.position.x = 0
		c.position.y = -100
		add_child(c)
		return
	if randf() < 0.1:
		var t = trampoline.instantiate()
		t.position.x = randi_range(-length/2+100, length/2-100)
		t.position.y = -50
		add_child(t)
		return

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if camera == null: 
		queue_free()
		return

	if camera.global_position.y < global_position.y:
		camera.limit_bottom = global_position.y
		emit_signal("removed")
		queue_free()
