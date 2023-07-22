extends Node2D

func _ready():
	$Player.visible = false
	$PlatformSpawner.visible = false
	$EnemySpawner.visible = false
	$CanvasLayer/HUD.visible = false
	$CanvasLayer/GameOver.visible = false
	$CanvasLayer/Menu.visible = true
	$CanvasLayer/GameOver/Score.text = "You got : " + str(GameManager.score)
func _on_player_killed() -> void:
	await get_tree().create_timer(2).timeout
	$CanvasLayer/HUD.visible = false
	$CanvasLayer/GameOver.visible = true

func _on_menu_play() -> void:
	GameManager.score = 0
	GameManager.coins = 0
	GameManager.carrots = 0
	GameManager.max_height = 0
	$PlatformSpawner.visible = true
	$Player.visible = true
	$Player.update_character()
	$EnemySpawner.visible = true
	$CanvasLayer/Menu.visible = false
	$CanvasLayer/HUD.visible = true
