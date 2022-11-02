# Código pegado do site do gdquest---==
class_name StateMachine
extends Node

signal transitioned(state_name)
export var initial_state := NodePath()

onready var state: State = get_node(initial_state)

var state_dict := Dictionary()

func _ready() -> void:
	yield(owner, "ready")
	
	for child in get_children():
		child.state_machine = self
		state_dict[child.name] = child
	state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return

	state.exit()
	state = state_dict[target_state_name	]
	state.enter(msg)
	emit_signal("transitioned", state.name)
