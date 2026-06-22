extends Area2D
@export var stick_data: StickData
@onready var sprite: Sprite2D = $Sprite2D
@onready var name_of: Label = $Popup/VBoxContainer/Name
@onready var desc: Label = $Popup/VBoxContainer/Desc
@onready var popup: Control = $Popup

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
