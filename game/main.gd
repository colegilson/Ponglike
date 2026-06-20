extends Node2D
@export var shop_scene: PackedScene
@export var minigames_scene: PackedScene
@export var game_scene: PackedScene
@onready var current: Node2D = $Game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().change_scene_to_file("res://game/game.tscn")
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func switch_scene()-> void:
	#current.game_won.disconnect(switch_to_minigames)
	#remove_child(current)
	#current = minigames_scene.instantiate()
	#add_child(current)
	#


func _on_game_game_won(player: String) -> void:
	remove_child(current)
	current = minigames_scene.instantiate()
	add_child(current)
	
