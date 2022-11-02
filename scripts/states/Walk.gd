extends PlayerState


func physics_update(delta):
	
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	var direction = Input.get_axis("left", "right")
	
	player.velocity.x = direction * player.run_speed
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {jump = true})
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif is_equal_approx(direction, 0.0):
		state_machine.transition_to("Idle")
