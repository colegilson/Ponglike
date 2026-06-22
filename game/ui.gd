class_name UI
extends CanvasLayer
@onready var transition: Control = $SceneTransition
@onready var bottom_text: RichTextLabel = $SceneTransition/VBoxContainer/BottomText
var accepted: bool = false
signal switched(player: String)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch_to(player:String) -> void:
	match player:
		"left":
			bottom_text.set_text("Please press D to confirm that you are Player 1.")
			transition.show()
			await wait_for_D()
			switched.emit(player)
			transition.hide()
		"right":
			bottom_text.set_text("Please press -> to confirm that you are Player 2.")
			transition.show()
			await wait_for_D()
			switched.emit(player)
			transition.hide()
	
func wait_for_D() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("left_attack"):
			return

func wait_for_forward() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("right_attack"):
			return
