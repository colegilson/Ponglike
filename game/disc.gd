extends RigidBody2D
@onready var right = Vector2(200,0)
@onready var left = Vector2(-200,0)
@onready var direction = right
@onready var dropped = false
@onready var settle_timer: Timer = $Timer
@onready var reward: int = 0
@onready var player: String = "left"

signal game_over(reward: int, player: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_gravity_scale(0.0)
	set_linear_velocity.call_deferred(direction)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if linear_velocity.y < 400 and linear_velocity.y > -400 and position.y > 1850:
		self.physics_material_override.friction = 1.0
		set_linear_velocity(Vector2.ZERO)
		if settle_timer.is_stopped():
			settle_timer.start(1)
	else:
		settle_timer.stop()
	if Input.is_action_just_pressed("space") and not dropped:
		dropped = true
		self.physics_material_override.friction = 0.4
		set_linear_velocity(Vector2(0,0))
		var gravity = get_gravity()
		set_gravity_scale(1.0)
		set_constant_force(gravity)
		physics_material_override.set_bounce(1.6)
	if not dropped:
		linear_velocity.y = 0
		if position.x > 800 or position.x < -800:
			if direction == right:
				direction = left
				set_linear_velocity(direction)
			else:
				direction = right
				set_linear_velocity(direction)
			OS.delay_msec(60)

func _on_timer_timeout() -> void:
	set_linear_velocity(Vector2.ZERO)
	print(reward)
	game_over.emit(reward, player)

func _on_area_2d_body_entered(body: Node2D) -> void:
	reward = 3

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	reward = 5

func _on_area_2d_3_body_entered(body: Node2D) -> void:
	reward = 0

func _on_area_2d_4_body_entered(body: Node2D) -> void:
	reward = 4

func _on_area_2d_5_body_entered(body: Node2D) -> void:
	reward = 2

func _on_area_2d_6_body_entered(body: Node2D) -> void:
	reward = 10
