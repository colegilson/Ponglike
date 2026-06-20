extends RigidBody2D
@onready var right = Vector2(200,0)
@onready var left = Vector2(-200,0)
@onready var direction = right
@onready var dropped = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_gravity_scale(0.0)
	set_linear_velocity.call_deferred(direction)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		dropped = true
		set_linear_velocity(Vector2(0,0))
		var gravity = get_gravity()
		set_gravity_scale(1.0)
		set_constant_force(gravity)
		physics_material_override.set_bounce(1.6)
	if not dropped:
		set_linear_velocity.call_deferred(direction)	


func _on_left_bound_body_entered(body: Node2D) -> void:
	direction = right
	

func _on_right_bound_body_entered(body: Node2D) -> void:
	direction = left
