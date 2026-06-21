@abstract
class_name State
extends Resource
var paddle: CharacterBody2D = null
var ball: CharacterBody2D = null

@export var animation_name: String
@export var move_speed: float

@abstract
func enter() #gets called by each state on entering a diff state, plays animation
	
	
@abstract
func exit()

	
func switch(state_name: String):
	if paddle:
		paddle.active_state.exit()
		paddle.switch_state(state_name)
		paddle.active_state.enter()
	if ball:
		ball.active_state.exit()
		ball.switch_state(state_name)
		ball.active_state.enter()	
