class_name BallData
extends Resource

#StateStuff:
@export var states: Array[State] = []
var state_name_dict: Dictionary[String,State] = {}
var active_state: State = null

@export var name: String
@export var bounce_coefficient: float
@export var return_speed: float
@export var superpower_scene: PackedScene
@export var basic_scene: PackedScene

func _ready() -> void:
	for state in states: 
			#state.ball = self
			state_name_dict[state.name] = state
	active_state = states[0]
	active_state.enter()
	
func switch_state(state_name: String):
	active_state = states.filter(func(s): return s.name == state_name)[0]

func physics_process(delta: float):
	if active_state.has_method("process"):
		active_state.process(delta)

func _unhandled_input(event: InputEvent) -> void:
	if active_state.has_method("input"):
		active_state.input(event)
