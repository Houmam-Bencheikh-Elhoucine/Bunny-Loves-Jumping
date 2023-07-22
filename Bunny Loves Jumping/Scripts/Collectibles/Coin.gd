extends Area2D

var value = 1
func _ready():
	$Sprite2D.play(["gold", "silver", "bronze"].pick_random())
	if $Sprite2D.animation == "gold":
		value = 5
	if $Sprite2D.animation == "silver":
		value = 2

func _on_body_entered(body: Node2D) -> void:
	GameManager.coins += value
	GameManager.score += 10
	queue_free()
