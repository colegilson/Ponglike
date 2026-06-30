extends RigidBody2D
@onready var right = Vector2(200,0)
@onready var left = Vector2(-200,0)
@onready var direction = right
@onready var dropped = false
@onready var settle_timer: Timer = $Timer
@onready var reward: int = 0
@onready var minigame_over_left: bool = false
@onready var minigame_over_right: bool = false
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX
@export var player: String
signal game_over(reward: int, player: String)
enum Phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKOL, PLINKOR }
@onready var right_bound: StaticBody2D = $"../Board/RightBound"
@onready var left_bound: StaticBody2D = $"../Board/LeftBound"

func _ready():
	contact_monitor = true
	max_contacts_reported = 20
	gravity_scale = 0
	set_linear_velocity(right)
	

# Called every frame. '_delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	match dropped:
		false:
			if Input.is_action_just_pressed("space"):
				dropped = true
				gravity_scale = 1.0
				set_linear_velocity(Vector2.ZERO)

			else:
				if global_position.x <= left_bound.global_position.x + 50.0:
					direction = right

				elif global_position.x >= right_bound.global_position.x - 50.0:
					direction = left

				set_linear_velocity(direction)
		true:
			if linear_velocity.y < 400 and linear_velocity.y > -400 and position.y > 950:
				#print(linear_velocity.y, "     ", position.y)
				physics_material_override.friction = 1.0
				set_linear_velocity(Vector2.ZERO)
				if settle_timer.is_stopped():
					settle_timer.start(1)
			else:
				settle_timer.stop()
				
			if linear_velocity.x < 10 and linear_velocity.x > -10 and settle_timer.is_stopped():
				linear_velocity.x = linear_velocity.x * 3
	
	

func _on_timer_timeout() -> void:
	set_linear_velocity(Vector2.ZERO)
	print(minigame_over_left, minigame_over_right)
	if not minigame_over_left and SaveData.current_phase == Phase.PLINKOL:
		player = "left"
		minigame_over_left = true
		game_over.emit(reward, player)
	if not minigame_over_right and SaveData.current_phase == Phase.PLINKOR:
		player = "right"
		minigame_over_right = true
		game_over.emit(reward, player)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		reward = 3

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body == self:
		reward = 5

func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body == self:
		reward = 0

func _on_area_2d_4_body_entered(body: Node2D) -> void:
	if body == self:
		reward = 4
		
func _on_area_2d_5_body_entered(body: Node2D) -> void:
	if body == self:
		reward = 2

func _on_area_2d_6_body_entered(body: Node2D) -> void:
	if body == self:
		reward = 10
		
