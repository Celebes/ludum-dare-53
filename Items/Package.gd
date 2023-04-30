class_name Package
extends RigidBody2D

const color_active := Color('#2bc106')
const color_white := Color('#ffffff')

onready var sprite := $Sprite

var player: Node = null

func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pick_up") and player:
		player.pick_up_package()
		queue_free()

func _on_PickupArea_body_entered(body: Node) -> void:
	if body is Player:
		player = body
		sprite.modulate = color_active

func _on_PickupArea_body_exited(body: Node) -> void:
	player = null
	sprite.modulate = color_white
