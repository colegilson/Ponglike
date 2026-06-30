extends Node2D
@onready var paused: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("forward_flip"):
		if paused:
			hide()
		else: 
			show()
		get_tree().paused = not get_tree().paused
		paused = not paused
