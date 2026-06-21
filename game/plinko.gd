extends Node2D
@export var bouncers: Array[PackedScene] 
@onready var points: Node2D = $Points
@onready var boings: Node2D = $Board/Boing
@onready var height_apex = 0
@onready var height_base = 0
@onready var reward_screen: Node2D = $game_over

signal minigame_over

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

func end_game() -> void:
	minigame_over.emit()


func _on_game_over(reward: int, player: String) -> void:
	
	if player == "left":
		reward_screen.get_child(1).text = "Player 1 wins %d Ringos!\nPress space to continue to Player 2!" % reward
		reward_screen.show()
		SaveData.money_left += reward
		await wait_for_space()
		reward_screen.hide()
#		restart_as P2
	if player == "right":
		reward_screen.get_child(1).text = "Player 2 wins %d Ringos!\nPress space to continue to Shop!" % reward
		reward_screen.show()
		SaveData.money_right += reward
		await wait_for_space()
		reward_screen.hide()
		
		end_game()
		
func wait_for_space() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("space"):
			return
