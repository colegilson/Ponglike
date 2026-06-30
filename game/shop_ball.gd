extends Area2D
var ball_data: BallData
@onready var sprite: Sprite2D = $BallSkin
@onready var name_of: Label = $Popup/VBoxContainer/Name
@onready var desc: Label = $Popup/VBoxContainer/Desc
@onready var popup: Control = $Popup
signal player_got(BallData)
@onready var price: Label = $Popup/VBoxContainer/Price

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ball_data:
		sprite.set_texture(ball_data.sprite)
		name_of.set_text(ball_data.name)
		desc.set_text(ball_data.description)
		price.set_text(str(ball_data.price)+"$")
	popup.hide()


# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	popup.show()



func _on_mouse_exited() -> void:
	popup.hide()


func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		player_got.emit(ball_data)
