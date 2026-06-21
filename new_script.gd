class_name State
extends Node

@export var animation_name: String
@export var move_speed: float

var parent: Paddle

func enter()-> void: #gets called by each state on entering a diff state, plays animation
	parent.animations.play(animation_name)
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	return null
	
func process_frame(delta: float) -> State: 
	return null
	
func process_physics(delta: float) -> State: #physics related updates
	return null
	
