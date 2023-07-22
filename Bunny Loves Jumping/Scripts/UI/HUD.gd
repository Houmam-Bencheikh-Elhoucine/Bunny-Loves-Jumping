extends Control

@onready var score = $Score
@onready var coins = $Coins
@onready var carrots = $Carrots
func _process(delta: float) -> void:
	score.text = "Score: "+str(GameManager.score)
	coins.text = " X " + str(GameManager.coins) + "    "
	carrots.text = " X " + str(GameManager.carrots) + "    "
