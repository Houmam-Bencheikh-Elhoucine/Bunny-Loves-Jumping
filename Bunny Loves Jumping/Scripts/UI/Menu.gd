extends Control

signal play

@onready var animator = $AnimationPlayer
@onready var play_button = $Play

var characters_visible = false

func _on_play_pressed() -> void:
	if not characters_visible:
		animator.play("Show_characters")
		play_button.text = "<- Select Character ->"
		characters_visible = true
	else:
		animator.play("hide_characters")
		play_button.text = "Play"
		characters_visible = false




func _on_boy_pressed() -> void:
	GameManager.player_gender = "boy"
	emit_signal("play")


func _on_girl_pressed() -> void:
	GameManager.player_gender = "girl"
	emit_signal("play")


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
