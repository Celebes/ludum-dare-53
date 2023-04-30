extends StaticBody2D

signal game_over

export var required_packages := 3

onready var label := $Label
onready var player := $"../Player"

var bodies := []

func _ready() -> void:
	update_label()

func _on_DropArea_body_entered(body: Node) -> void:
	if body is Package:
		bodies.append(body)
		update_label()

func _on_DropArea_body_exited(body: Node) -> void:
	if body is Package:
		bodies.erase(body)
		update_label()

func update_label():
	var remaining_packages := required_packages - bodies.size()
	label.text = str(remaining_packages)
	if remaining_packages == 0:
		emit_signal("game_over")
