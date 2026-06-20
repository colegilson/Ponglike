extends Node2D
@export var bouncers: Array[PackedScene] 
@onready var points: Node2D = $Points
@onready var boings: Node2D = $Board/Boing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spots = points.get_children()
	var i = 0
	
	for spot in spots:
		if i%3:
			i += 1
		else: i = 1	
		var scene = bouncers[i]
		var bouncer = scene.instantiate()
		boings.add_child(bouncer)
		bouncer.global_position = spot.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
