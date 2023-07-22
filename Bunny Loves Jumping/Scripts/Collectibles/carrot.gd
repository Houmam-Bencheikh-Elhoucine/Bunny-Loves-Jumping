extends Area2D

var textures = []
var value = 1

func _on_body_entered(body: Node2D) -> void:
	GameManager.carrots += 1
	GameManager.score += 10
	queue_free()
