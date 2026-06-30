class_name Ball
extends CharacterBody2D

@onready var fxl: Node2D = $FXL
@onready var fxr: Node2D = $FXR
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_sfx: AudioStreamPlayer2D = %HitSFX
enum phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKOL, PLINKOR }
enum state { L_RECEIVE, L_EMIT, R_RECEIVE, R_EMIT }
var symergy
const MOVE_SPEED: float = 400.0 #moving this down from 550 to allow time for debugging
signal hit_paddle(paddle: CharacterBody2D)
var aiming: bool = false
@export var ball_data: BallData
@onready var slowed: bool = false 
@onready var shuffled


func _ready() -> void:
	if ball_data:
		SaveData.current_right_ball = ball_data
		SaveData.current_left_ball = ball_data
		apply_ball_data(ball_data)

func current_stick_is(data: StickData) -> bool:
	match SaveData.current_state:
		state.L_RECEIVE:
			return SaveData.current_left_stick == data
		state.L_EMIT: 
			return SaveData.current_left_stick == data
		state.R_RECEIVE:
			return SaveData.current_right_stick == data
		state.R_EMIT:
			return SaveData.current_right_stick == data
	return false
	
		
func apply_ball_data(data: BallData) -> void:
	ball_data = data
	
	sprite.texture = ball_data.sprite
	hit_sfx.stream = ball_data.sfx
	_update_particles()


func _physics_process(delta: float) -> void:
	#if SaveData.current_phase != phase.PONG:
		#return
	if not aiming:
		_ball_physics(delta)
	match SaveData.current_state:
		state.L_RECEIVE:
			if SaveData.current_left_stick.name == "Pongo Bongo" and not slowed:
				slowed = true
				var nerf = SaveData.current_left_stick.speed_nerf
				print(nerf)
				temp_speed_change("left", nerf)
				SaveData.number_to_change = 1
				hit_sfx.stream = SaveData.current_left_stick.sfx
				hit_sfx.play()
			if Input.is_action_just_pressed("left_attack") and SaveData.current_left_ball.name == "Slingo Casino":
				SaveData.shop_queue_left_ball.shuffle()
				SaveData.shop_queue_left_stick.shuffle()
				shuffled = GameUtility.get_UI().find_child("shuffled")
				shuffled.set_text("Slingo Switch-up! - Your shop queue has spun its reels.")
				shuffled.show()
				await get_tree().create_timer(3).timeout
				shuffled.hide()
		state.L_EMIT: 
			if Input.is_action_just_pressed("left_attack") and SaveData.current_left_ball.name == "Slingo Casino":
				SaveData.shop_queue_right_ball.shuffle()
				SaveData.shop_queue_right_stick.shuffle()
				shuffled = GameUtility.get_UI().find_child("shuffled")				
				shuffled.set_text("Slingo Switch-up! - Your opponent's queue has spun its reels.")
				shuffled.show()
				await get_tree().create_timer(3).timeout
				shuffled.hide()
		state.R_RECEIVE:
			if SaveData.current_right_stick.name == "Pongo Bongo" and not slowed:
				slowed = true
				var nerf = SaveData.current_right_stick.speed_nerf
				print(nerf)
				temp_speed_change("right", nerf)
				SaveData.number_to_change = 1
				hit_sfx.stream = SaveData.current_right_stick.sfx
				hit_sfx.play()
			if Input.is_action_just_pressed("right_attack") and SaveData.current_right_ball.name == "Slingo Casino":
				SaveData.shop_queue_right_ball.shuffle()
				SaveData.shop_queue_right_stick.shuffle()
				shuffled = GameUtility.get_UI().find_child("shuffled")
				shuffled.set_text("Slingo Switch-up! - Your shop queue has spun its reels.")
				shuffled.show()
				await get_tree().create_timer(3).timeout
				shuffled.hide()
		state.R_EMIT:
			if Input.is_action_just_pressed("right_attack") and SaveData.current_right_ball.name == "Slingo Casino":
				SaveData.shop_queue_left_ball.shuffle()
				SaveData.shop_queue_left_stick.shuffle()
				shuffled = GameUtility.get_UI().find_child("shuffled")
				shuffled.set_text("Slingo Switch-up! - Your opponent's queue has spun its reels.")
				shuffled.show()
				await get_tree().create_timer(3).timeout
				shuffled.hide()
	

# Override this in special balls.
func _ball_physics(delta: float) -> void:
	if not velocity:
		return
	
	var collision := move_and_collide(velocity * delta)
	if not collision:
		return
	
	var collision_normal := collision.get_normal()
	var collision_object := collision.get_collider()

	_collide_with(collision_object, collision_normal)
	

	

# Override this if a special ball has weird collision behavior.
func _collide_with(body: Object, normal: Vector2) -> void:
	if body is Paddle:
		hit_paddle.emit(body)
		_on_paddle_hit(body)
		print("defo hit paddle")

	velocity = velocity.bounce(normal)



# Override this if special balls do different stuff on paddle hit.
func _on_paddle_hit(paddle: Paddle) -> void:
	match SaveData.current_state:
		state.L_EMIT:
			print("not changing states?")
			slowed = false
			if ball_data.sfx and not SaveData.current_left_stick.name == "Pool Cue" and not SaveData.current_left_stick.name == "Pongo Bongo":
				hit_sfx.play()
			else: pass #add default sfx here #TODO
			if ball_data.name == "8 Ball" and SaveData.current_left_stick.name == "Pool Cue":
				print("pool and cue 1")
				aiming = true
				cue_and_pool("left")
			if ball_data.name == "Baseball" and SaveData.current_left_stick.name == "Baseball Bat":
				SaveData.number_to_change = 2
				temp_speed_change("left", 2.5)
			if SaveData.current_left_stick.name == "Magic Wand":
				self.apply_scale(Vector2(0.5, 0.5))
				await get_tree().create_timer(randi_range(4, 7)).timeout
				self.apply_scale(Vector2(2, 2))
		state.R_EMIT:
			print("not changing states?")
			if ball_data.sfx and not SaveData.current_right_stick.name == "Pool Cue" and not SaveData.current_right_stick.name == "Pongo Bongo":
				hit_sfx.play()
			else: pass #add default sfx here #TODO
			if ball_data.name == "8 Ball" and SaveData.current_right_stick.name == "Pool Cue":
				aiming = true
				cue_and_pool("right")
				print("pool and cue 2")
			if ball_data.name == "Baseball" and SaveData.current_right_stick.name == "Baseball Bat":
				SaveData.number_to_change = 2
				temp_speed_change("right", 2.5)
			if SaveData.current_right_stick.name == "Magic Wand":
				self.apply_scale(Vector2(0.5, 0.5))
				await get_tree().create_timer(randi_range(4, 7)).timeout
				self.apply_scale(Vector2(2, 2))
			
func temp_speed_change(player: String, nerf: float) -> void:
	var current_state = SaveData.current_state
	match player:
		"left": 
			velocity *= nerf
			print("multiplying speed by " + str(nerf))
			while SaveData.current_state != (current_state+SaveData.number_to_change) % 4:
				await get_tree().process_frame
			velocity /= nerf
			hit_sfx.stream = ball_data.sfx
			print("putting it back")
		"right":
			velocity *= nerf
			print("multiplying speed by " + str(nerf))
			while SaveData.current_state != (current_state+SaveData.number_to_change) % 4:
				await get_tree().process_frame
			velocity /= nerf
			hit_sfx.stream = ball_data.sfx
			print("putting it back")
			
func cue_and_pool(player: String) -> void:
	match player:
		"left":
			print("pool and cue 3 ")
			var arrow = SaveData.current_left_stick.superpower_scene.instantiate()
			add_child(arrow)
			arrow.scale.x = 4.0
			arrow.scale.y = 4.0
			arrow.position = Vector2(40, 0)
			while not Input.is_action_just_pressed("left_attack"):
				await get_tree().process_frame
			var arrow_rotation = Vector2.RIGHT.rotated(arrow.rotation)
			set_direction(arrow_rotation)
			arrow.queue_free()
			aiming = false
			hit_sfx.play()
		"right":
			print("pool and cue4 ")
			var arrow = SaveData.current_right_stick.superpower_scene.instantiate()
			add_child(arrow)
			arrow.scale.x = -4.0
			arrow.scale.y = 4.0
			arrow.position = Vector2(-40, 0)
			while not Input.is_action_just_pressed("right_attack"):
				await get_tree().process_frame
			var arrow_rotation = Vector2.LEFT.rotated(arrow.rotation)
			set_direction(arrow_rotation)
			arrow.queue_free()
			aiming = false
			hit_sfx.play()
			
func set_direction(direction: Vector2) -> void:
	if not direction:
		velocity = Vector2.ZERO
		return
	
	velocity = direction.normalized() * MOVE_SPEED


func _update_particles() -> void:
	_clear_particles(fxl)
	_clear_particles(fxr)

	if not ball_data:
		return

	if not ball_data.particle_scene:
		return

	var particles = ball_data.particle_scene.instantiate()

	match SaveData.current_state:
		state.L_EMIT:
			fxl.add_child(particles)
		state.L_RECEIVE:
			fxl.add_child(particles)
		state.R_EMIT:
			fxr.add_child(particles)
		state.R_RECEIVE:
			fxr.add_child(particles)


func _clear_particles(parent: Node2D) -> void:
	for child in parent.get_children():
		child.queue_free()
