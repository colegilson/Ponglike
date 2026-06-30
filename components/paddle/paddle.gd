class_name Paddle
extends CharacterBody2D
@export var player: String 
@export var stick_data: StickData
const MOVE_SPEED: float = 300

var input: float = 0.0
var target: Node2D = null
@onready var sprite: Sprite2D = $Sprite2D
@onready var paddle_fxr: Node2D = $PaddleFXR
@onready var paddle_fxl: Node2D = $PaddleFXL
@onready var paddle_index: int = 0
@onready var sfxl: AudioStreamPlayer = $PaddleFXL/SFXL
@onready var sfxr: AudioStreamPlayer = $PaddleFXR/SFXR
@onready var effects
@onready var effect_l
@onready var effect_r
var ciggy_on = false
var ciggy_started = 0
var ciggy_duration = 60
var ciggy_elapsed = 0
@onready var cig_holder: Control = $CigHolder
@onready var cig_holder_r: Control = $CigHolder2

func _ready() -> void:
	match self.player:
		"left": 
			effects = paddle_fxl
			SaveData.current_left_stick = stick_data
			
		"right": 
			effects = paddle_fxr
			SaveData.current_right_stick = stick_data
			
# If a target is set (i.e. AI paddle), follow it
# Otherwise rely on manual input
func _physics_process(delta: float) -> void:
	if target:
		_follow_target()
	else:
		_follow_input()
	#print(SaveData.stick_inventory_left)
	move_and_collide(velocity * delta)
	if ciggy_on:
		ciggy_elapsed += delta
		if self.player == "left": SaveData.ciggy_percent_l = (ciggy_elapsed * 0.6)
		else: SaveData.ciggy_percent_r = (ciggy_elapsed * 0.6)

# Update velocity based on input
func _follow_input() -> void:
	input = clampf(input, -1.0, 1.0)
	velocity.y = input * MOVE_SPEED


# Follow current target
func _follow_target() -> void:
	if not target: return
	
	var diff := target.global_position.y - global_position.y
	var direction := clampf(diff, -1.0, 1.0)
	velocity.y = direction * MOVE_SPEED

func _switch_to_next()-> void:
	if self.player == "left":
		print("Player left switches paddle")
		if SaveData.stick_inventory_left.size() < 1:
			return
		if SaveData.stick_inventory_left.size() == 1:
			paddle_index = 0
		if SaveData.stick_inventory_left.size() > 0:
			paddle_index = (paddle_index + 1) % SaveData.stick_inventory_left.size()
		var stick = SaveData.stick_inventory_left[(paddle_index)]
		SaveData.current_left_stick = stick
		apply_stick_data(stick, "left")
		print("left switched to "+ stick.name)
		print("index is " + str(paddle_index))
		try_ciggy_on("left")
	if self.player == "right":
		if SaveData.stick_inventory_right.size() < 1:
			return
		if SaveData.stick_inventory_right.size() == 1:
			paddle_index = 0
		print("Player right switches paddle")
		if SaveData.stick_inventory_right.size() >= 1:
			paddle_index = (paddle_index + 1) % SaveData.stick_inventory_right.size()
		var stick = SaveData.stick_inventory_right[(paddle_index)]
		SaveData.current_right_stick = stick
		apply_stick_data(stick, "right")
		print("right switched to "+ stick.name)
		print("index is " + str(paddle_index))
		try_ciggy_on("right")
			
func apply_stick_data(data: StickData, player: String) -> void:
	stick_data = data
	match player:
		"left":
			SaveData.current_left_stick = data
		"right":
			SaveData.current_right_stick = data
	sprite.texture = data.sprite
	#match data.name:
		#pass
	if data.particle_trail:
		_clear_particles(effects)
		var new = data.particle_trail.instantiate()
		effects.add_child(new)
	else: _clear_particles(effects)
			
#func clear_particles(scene: PackedScene) -> void:
	#effects. WIP WIP WIP
	
func try_ciggy_on(player:String):
	match player:
		"right":
			if not ciggy_on and SaveData.current_right_stick.name == "Ciggy":
				ciggy_on = true
				var used = GameUtility.get_game().r_used
				if not used: 
					effect_r = SaveData.current_right_stick.superpower_scene.instantiate()
					effect_r.set_meta("left", false)
					cig_holder_r.add_child(effect_r)
					GameUtility.get_game().use_cig("right")
					ciggy_started = Time.get_unix_time_from_system()
					ciggy_elapsed = SaveData.r_cig_elapsed
				if effect_r: effect_r.show()
				else:
					effect_r = SaveData.current_right_stick.superpower_scene.instantiate()
					effect_r.set_meta("left", false)
					cig_holder_r.add_child(effect_r)
					ciggy_elapsed = SaveData.r_cig_elapsed

				sprite.hide()
				self.scale.x = 1.5
				self.scale.y = 3
			else: 
				ciggy_on = false
				SaveData.r_cig_elapsed = ciggy_elapsed
				ciggy_elapsed = 0
				ciggy_started = 0
				sprite.show()
				if effect_r:
					effect_r.hide()
		"left":
			if not ciggy_on and SaveData.current_left_stick.name == "Ciggy":
				ciggy_on = true
				var used = GameUtility.get_game().l_used
				if not used: 
					effect_l = SaveData.current_left_stick.superpower_scene.instantiate()
					effect_l.set_meta("left", true)
					cig_holder.add_child(effect_l)
					GameUtility.get_game().use_cig("left")
					ciggy_started = Time.get_unix_time_from_system()
					ciggy_elapsed = SaveData.l_cig_elapsed
				if effect_l: effect_l.show()
				else:
					effect_l = SaveData.current_left_stick.superpower_scene.instantiate()
					effect_l.set_meta("left", true)
					cig_holder.add_child(effect_l)
					ciggy_elapsed = SaveData.l_cig_elapsed

				sprite.hide()
				self.scale.x = 1.5
				self.scale.y = 3
			else: 
				ciggy_on = false
				SaveData.l_cig_elapsed = ciggy_elapsed
				ciggy_elapsed = 0
				ciggy_started = 0
				if effect_l:
					effect_l.hide()
				sprite.show()
			

func _clear_particles(parent: Node2D) -> void:
	for child in parent.get_children():
		child.queue_free()
			
func collision_fx() -> void: #for explosive collision effects
	if stick_data:
		if stick_data.constant_fx:
			return
		if not stick_data.particle_trail:
			return
		if effects.get_child(0) != sfxl and effects.get_child(0) != sfxr:
			effects.get_child(0).restart()
		
