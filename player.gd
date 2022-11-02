extends KinematicBody2D

export (int) var run_speed = 400
export (int) var jump_speed = -650
export (int) var gravity = 1400

onready var timer =  get_node("Timer")
export (NodePath) onready var label
var velocity = Vector2()
# direção q tá indo 1 = direita 2 = esquerda
var direction = 1
var wallDirection = 0
var jumping = false
var falling = false
# caso o botão não esteja pressionado == true
var released = true
# estado do dash 

# ground     pra dash do chão
# airDash    pra dash aéreo
# SuperJump  pra o dash com pulo

# Não tem wallDash ainda mas isso vc faz
var dashState = ""
# bloqueio de airDash extra no ar
var blockDash = false
# momentum no superJump
var momentum = false
func _ready():
	#timeout do timer
	timer.connect("timeout", null, "Timeout")
func get_input():
	velocity.x = 0
	# escadinha
	var left = Input.is_action_pressed('left')
	var right = Input.is_action_pressed('right')
	var jump = Input.is_action_just_pressed('jump')
	var dash = Input.is_action_just_pressed('dash')
	var stopJump = Input.is_action_just_released('jump')
	var stopDash = Input.is_action_just_released('dash')
	
	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	if jumping and is_on_wall():
		jumping = false
	if jump and not is_on_floor() and is_on_wall():
		velocity.y = jump_speed
		if wallDirection == 1:
			direction = 2
		dash(false)
	# caso solte o botão de jump no ar ele para o pulo
	if stopJump and not is_on_floor() and not falling and velocity.y < 0:
		falling = true
		velocity.y = 0
	# direita e esquerda
	if right:
		direction = 1
		#if is_on_wall():
			#print("true")
		# eu meio q usei a func do dash pra movimento tmb k
		dash(false)
	if left:
		#if is_on_wall():
			#print("true")
		direction = 2
		dash(false)
	# se apertar o botão de dash, released pra n ficar infinito e o blockDash no airDash
	if dash and released and not blockDash:
		timer.start(timer.get_wait_time())
		timer.set_one_shot(true)
		released = false
		if is_on_floor():
			dashState = "ground"
		else:
			dashState = "airDash"
	# caso solte o botão de dash
	if stopDash:
		# se o dash começou no chão e acabou no ar vira superJump
		if dashState == "ground" and not is_on_floor():
			dashState = "superJump"
		# se n for dash ground ele faz o airDash
		elif dashState == "airDash":
			# pra n ter airDash extra
			blockDash = true
			# sem dash mais
			dashState = ""
		# se for um de ground e tiver no chão, sem dash mais
		elif dashState == "ground" and is_on_floor():
			dashState = ""
		released = true
		timer.stop()

func _physics_process(delta):
	get_input()
	# gravidade
	velocity.y += gravity * delta
	# qualquer tipo de dash
	if dashState != "" and not timer.is_stopped():
		#print(timer.time_left)
		dash(true)
	# ativador instantanio de superJump pra facilitar
	if dashState == "ground" and not is_on_floor():
		dashState = "superJump"
	# pulo (wathever)
	if jumping and is_on_floor():
		jumping = false
	# reseta o blockDash quando encosta no chão
	if blockDash and is_on_floor():
		blockDash = false
	# reseta o falling quando encosta no chão
	if falling and is_on_floor():
		falling = false

	# reseta o superJump quando encosta no chão
	if dashState == "superJump" and is_on_floor():
		dashState = ""
	# o segredo do superJump
	if dashState == "superJump" and not is_on_floor():
		momentum = true
	else:
		momentum = false
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
func Timeout():
	print("timeout")
	# se o dash começou no chão e acabou no ar vira superJump
	if dashState == "ground" and not is_on_floor():
		dashState = "superJump"
	# se n for dash ground ele faz o airDash
	elif dashState == "airDash":
		# pra n ter airDash extra
		blockDash = true
		# sem dash mais
		dashState = ""
	# se for um de ground e tiver no chão, sem dash mais
	elif dashState == "ground" and is_on_floor():
		dashState = ""

func dash(is_dash):
	var vel = run_speed
	# caso seja dash ou momentum
	if is_dash or momentum:
		# dash é 2x mais rapido
		vel = 600
		# zerando o y pra o airDash
		if dashState == "airDash":
			velocity.y = 0
	# direita
	if direction == 1:
		#print("direita")
		velocity.x += vel
	# esquerda
	elif direction == 2:
		#print("esquerda")
		velocity.x -= vel
	pass


func _on_esquerda_body_entered(body):
	if body.name != "player":
		wallDirection = 2
		pass
	pass # Replace with function body.


func _on_direita_body_entered(body):
	if body.name != "player":
		wallDirection = 1
		pass
	pass # Replace with function body.


func _on_esquerda_body_exited(body):
	if body.name != "player":
		wallDirection = 0
		pass
	pass # Replace with function body.


func _on_direita_body_exited(body):
	if body.name != "player":
		wallDirection = 0
		pass
	pass # Replace with function body.
