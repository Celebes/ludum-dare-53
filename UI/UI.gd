extends Control

const icon_jump = preload("res://UI/jump_icon.png")
const icon_package = preload("res://UI/package_icon.png")

const color_active := Color('#2bc106')
const color_disabled := Color('#313431')
const color_white := Color('#ffffff')

onready var player := $"../../Player"
onready var icon1 := $VBoxContainer/HBoxContainer/Icon1
onready var icon2 := $VBoxContainer/HBoxContainer/Icon2
onready var icon3 := $VBoxContainer/HBoxContainer/Icon3

var icons: Array

func _ready() -> void:
	icons = [icon1, icon2, icon3]
	player.connect("player_state_changed", self, "update_icons")
	update_icons()

func update_icons() -> void:
	var total_jumps = player.max_jumps - player.packages
	var remaining_jumps = total_jumps - player.current_jumps
	for i in range(player.max_jumps):
		var icon = icons[i]
		
		if i < total_jumps:
			icon.texture = icon_jump
		else:
			icon.texture = icon_package
			
		if i < remaining_jumps:
			icon.modulate = color_active
		elif i >= total_jumps:
			icon.modulate = color_white
		else:
			icon.modulate = color_disabled

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
