extends Node2D

@export var max_angle := 1.8 #max angle in rads
@export var speed := 2.0

var time := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	rotation = sin(time* speed) * max_angle
