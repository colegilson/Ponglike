extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	velocity += get_gravity()*delta
	move_and_collide(velocity)
	
	if collision:
		var normal = collision.get_normal()
		velocity = velocity.bounce(normal)

	
