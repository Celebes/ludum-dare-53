class_name Player
extends KinematicBody2D

signal player_state_changed

onready var jump_audio_player := $JumpAudioPlayer
onready var jump_failed_audio_player := $JumpFailedAudioPlayer
onready var pickup_audio_player := $PickupAudioPlayer
onready var drop_audio_player := $DropAudioPlayer
onready var animation_tree := $AnimationTree
onready var animation_state := animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback

export var max_speed := 300.0
export var gravity := 400.0
export var jump_strength := 400.0
export var gliding_speed := 150.0

var velocity := Vector2.ZERO
var max_jumps := 3
var packages := 0
var current_jumps := 0
var last_direction := 1

func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:	
	if is_on_floor() and current_jumps > 0:
		for index in get_slide_count():
			var collision := get_slide_collision(index)
			if collision.collider is RigidBody2D:
				pass
			else:
				update_current_jumps(0)
	
	var h_direction = Input.get_axis("move_left", "move_right")
	
	if (abs(h_direction) > 0.1):
		last_direction = h_direction

	if get_slide_count() > 0 or abs(velocity.x) < 0.1:
		# allow moving and stopping when on the ground
		velocity.x = h_direction * max_speed
	elif ((abs(h_direction) > 0.1) and (sign(velocity.x) != sign(h_direction))):
		# change direction mid air when gliding
		velocity.x *= -1.0

	velocity = velocity.move_toward(Vector2(velocity.x, gliding_speed), gravity * delta)
	
	if Input.is_action_just_pressed("jump"):
		if can_jump():
			velocity.y = -jump_strength
			update_current_jumps(current_jumps + 1)
			animation_state.travel("Fly")
			jump_audio_player.play()
		else:
			jump_failed_audio_player.play()
	elif (velocity.y < 0.0) and Input.is_action_just_released("jump"):
		velocity.y = 0.0

	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI / 4, false)
	update_animations()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop") and packages > 0:
		drop_package()

func can_jump() -> bool:
	return (max_jumps - packages - current_jumps) > 0

func update_current_jumps(new_value: int) -> void:
	current_jumps = new_value
	emit_signal("player_state_changed")

func drop_package() -> void:
	drop_audio_player.play()
	packages -= 1
	emit_signal("player_state_changed")
	var dropped_package = load("res://Items/Package.tscn").instance()
	get_tree().current_scene.add_child(dropped_package)
	var new_position = global_position
	new_position.y += 1
	dropped_package.global_position = new_position

func pick_up_package() -> void:
	pickup_audio_player.play()
	packages += 1
	emit_signal("player_state_changed")

func update_animations() -> void:
	var blend_position = Vector2(last_direction, 0)
	animation_tree.set("parameters/Idle/blend_position", blend_position)
	animation_tree.set("parameters/Walk/blend_position", blend_position)
	animation_tree.set("parameters/Fly/blend_position", blend_position)
	
	if get_slide_count() == 0:
		animation_state.travel("Fly")
	else:
		if abs(velocity.x) > 0.1:
			animation_state.travel("Walk")
		else:
			animation_state.travel("Idle")
