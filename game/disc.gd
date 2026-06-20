extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gravity = get_gravity()
	set_constant_force(gravity)
	physics_material_override.set_bounce(1.6)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
