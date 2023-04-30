extends Area2D

onready var sound := $AudioStreamPlayer

func _ready() -> void:
	connect("body_entered", self, "restart_level")

func restart_level(body: Node) -> void:
	if body is Player or body is Package:
		sound.play()
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().reload_current_scene()
