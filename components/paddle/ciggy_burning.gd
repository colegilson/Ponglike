extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.get_meta("left"):
		self.value = 100 - SaveData.ciggy_percent_l
	else:
		self.value = 100 -SaveData.ciggy_percent_r
