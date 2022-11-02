extends PlayerState


func enter(msg:={}):
	if msg.has("jump"):
		player.velocity.y = -player.jump_speed

func physics_update(delta):
	var direction = Input.get_axis("left","right")
	
	player.velocity.x = player.run_speed * direction
	
	if Input.is_action_just_released("jump") and player.velocity.y <= 0:
		player.velocity.y = -13
	
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	
	if player.is_on_floor():
		if is_equal_approx(direction, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
