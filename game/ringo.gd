extends AnimatableBody2D

@onready var sprite: AnimatedSprite2D = $RingoSprite

var is_flipping: bool = false
var original_scale_y: float
var tween: Tween

func _ready() -> void:
	original_scale_y = sprite.scale.y

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("forward_flip"):
		forward_flip()

func forward_flip() -> void:
	if is_flipping:
		return
	is_flipping = true

	tween = create_tween()
	tween.tween_property(sprite, "scale:y", 0.0, 0.12)
	tween.tween_callback(func() -> void:
		sprite.flip_v = true
	)
	tween.tween_property(sprite, "scale:y", original_scale_y, 0.12)
	tween.tween_property(sprite, "scale:y", 0.0, 0.12)
	tween.tween_callback(func() -> void:
		sprite.flip_v = false
	)
	tween.tween_property(sprite, "scale:y", original_scale_y, 0.12)
	tween.tween_callback(func() -> void:
		is_flipping = false
	)
