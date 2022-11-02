class_name Player
extends KinematicBody2D

export (int) var run_speed = 400
export (int) var dash_speed = 600
export (int) var jump_speed = 650
export (int) var gravity = 1400

onready var label = $"../Label"
var velocity := Vector2()
var last_direction: int = 1

func _physics_process(delta):
	var direction = Input.get_axis("left","right")
	if direction != 0:
		last_direction = sign(direction)


func _on_StateMachine_transitioned(state_name):
	label.text = state_name
