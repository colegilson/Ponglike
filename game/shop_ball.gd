extends Sprite2D
@export var ball_data: BallData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.texture = ball_data.sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
