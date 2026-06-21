extends CharacterBody2D
class_name Paddle
@export var states: Array[State] = []
var state_name_dict: Dictionary[String,State] = {}
var active_state: State = null


const MOVE_SPEED: float = 300

var input: float = 0.0
var target: Node2D = null

func _ready() -> void:
	for state in states: 
		state.paddle = self
		state_name_dict[state.name] = state
	active_state = states[0]
	active_state.enter()
	
func switch_state(state_name: String):
	active_state = states.filter(func(s): return s.name == state_name)[0]
# If a target is set (i.e. AI paddle), follow it
# Otherwise rely on manual input
func _physics_process(delta: float) -> void:
	if active_state.has_method("process"):
		active_state.process(delta)
	if target:
		_follow_target()
	else:
		_follow_input()
	
	move_and_collide(velocity * delta)
	
func _unhandled_input(event: InputEvent) -> void:
	if active_state.has_method("input"):
		active_state.input(event)

# Update velocity based on input
func _follow_input() -> void:
	input = clampf(input, -1.0, 1.0)
	velocity.y = input * MOVE_SPEED


# Follow current target
func _follow_target() -> void:
	if not target: return
	
	var diff := target.global_position.y - global_position.y
	var direction := clampf(diff, -1.0, 1.0)
	velocity.y = direction * MOVE_SPEED
