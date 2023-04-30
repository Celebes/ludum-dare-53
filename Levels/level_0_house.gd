extends Node2D

onready var game_over_panel := $GameOver
onready var finish_plate := $FinishPlate

func _ready() -> void:
	get_tree().paused = false
	game_over_panel.visible = false
	finish_plate.connect("game_over", self, "show_game_over_panel")
	
func show_game_over_panel() -> void:
	game_over_panel.visible = true
	get_tree().paused = true
