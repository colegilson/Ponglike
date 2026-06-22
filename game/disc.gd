extends RigidBody2D
@onready var right = Vector2(200,0)
@onready var left = Vector2(-200,0)
@onready var direction = right
@onready var dropped = false
@onready var settle_timer: Timer = $Timer
@onready var reward: int = 0
@onready var player: String = "left"
@onready var minigame_over: bool = false
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX
signal game_over(reward: int, player: String)
#@export var gravity_multiplier := 2.0

func _ready():
	contact_monitor = true
	gravity_scale = 1.0
	linear_velocity = right
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	print(hit_sfx.is_playing())
	if linear_velocity.y < 400 and linear_velocity.y > -400 and position.y > 1850:
		#physics_material_override.friction = 1.0
		set_linear_velocity(Vector2.ZERO)
		if settle_timer.is_stopped():
			settle_timer.start(1)
	else:
		settle_timer.stop()
	if Input.is_action_just_pressed("space") and not dropped:
		dropped = true
		set_linear_velocity(Vector2(0,0))
		move_and_collide(get_linear_velocity())
		physics_material_override.set_bounce(0.8)
	if not dropped:
		set_linear_velocity(direction)

		if position.x > 800:
			direction = left
			position.x = 800
			set_linear_velocity(direction)

		elif position.x < -800:
			direction = right
			position.x = -800
			set_linear_velocity(direction)
	print("gravity scale: ", gravity_scale)
	print("gravity: ", get_gravity())
	print("velocity: ", linear_velocity)
	print(ProjectSettings.get_setting("physics/2d/default_gravity"))
	#var collision := move_and_collide(get_linear_velocity())
	#if not collision:
		#return
	#if not hit_sfx.is_playing():
		#hit_sfx.play()

func _on_timer_timeout() -> void:
	set_linear_velocity(Vector2.ZERO)
	if not minigame_over:
		minigame_over = true
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
