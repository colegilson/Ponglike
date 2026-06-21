extends Node2D
@export var bouncers: Array[PackedScene] 
@onready var points: Node2D = $Points
@onready var boings: Node2D = $Board/Boing
@onready var height_apex = 0
@onready var height_base = 0
@onready var reward_screen: Node2D = $game_over
@onready var win_text: Label = $game_over/HBoxContainer/WinText
@onready var press_space: Label = $game_over/HBoxContainer/PressSpace
signal balance_update
signal minigame_over
var current_player = SaveData.current_user
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



func _on_game_over(reward: int, player: String) -> void:
	if player == "left":
		balance_update.emit("left", reward)
		win_text.text = "Player 1 wins %d Ringos!" % reward
		press_space.text = "Press space to continue to Player 2!"
		SaveData.left_won = reward
		reward_screen.show()
		await wait_for_space()
		reward_screen.hide()
#		restart_as P2
	if player == "right":
		balance_update.emit("right", reward)
		win_text.text = "Player 2 wins %d Ringos!" % reward
		press_space.text = "Press space to continue to shop!"
		reward_screen.show()
		await wait_for_space()
		reward_screen.hide()
		SaveData.right_won = reward
		minigame_over.emit()
		
		
func wait_for_space() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("space"):
			return
