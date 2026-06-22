extends Area2D
var stick_data: StickData
@onready var sprite: Sprite2D = $Sprite2D
@onready var name_of: Label = $Popup/VBoxContainer/Name
@onready var desc: Label = $Popup/VBoxContainer/Desc
@onready var popup: Control = $Popup
signal player_got(StickData)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if StickData:
		sprite.set_texture(stick_data.sprite)
		name_of.set_text(stick_data.name)
		desc.set_text(stick_data.description)
	popup.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	popup.show()



func _on_mouse_exited() -> void:
	popup.hide()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		player_got.emit(stick_data)
