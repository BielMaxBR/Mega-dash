extends PlayerState

onready var timer = $"../../Timer"

var last_direction: int = 1
func enter(msg:={}):
	timer.start()
	if not timer.is_connected("timeout", self, "_timeout"):
		timer.connect("timeout", self, "_timeout")
	last_direction = player.last_direction

func physics_update(delta):
	player.velocity.x = last_direction * player.dash_speed
	player.velocity.y = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_just_released("dash"):
		timer.stop()
		_transition()
	
	if player.is_on_wall():
		state_machine.transition_to("Wall")

func _transition():
	if player.is_on_floor():
		if Input.get_axis("left","right") == 0:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Air")

func _timeout():
	_transition()
