extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {jump = true})
		
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		
	elif Input.get_axis("left", "right") != 0:
		state_machine.transition_to("Walk")
