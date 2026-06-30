# UI.gd
class_name UI
extends CanvasLayer

# ── Children ──────────────────────────────────────────────────────────────────
@onready var transition:   Control        = $SceneTransition
@onready var top_text:     RichTextLabel  = $SceneTransition/VBoxContainer/TopText
@onready var bottom_text:  RichTextLabel  = $SceneTransition/VBoxContainer/BottomText
@onready var shuffled: Label = %shuffled
@onready var bg: TextureRect = $bg

signal switched(context: String)

# ─────────────────────────────────────────────────────────────────────────────
func _ready() -> void:
	transition.hide()
	shuffled.hide()
	bg.hide()
# ── Public API ────────────────────────────────────────────────────────────────
func set_destination(label: String) -> void:
	top_text.set_text(label)

## Show a blocking prompt and wait for the correct player to confirm.
## `player` is "left" or "right".
func prompt_for_shop(player: String) -> void:
	match player:
		"left":
			bottom_text.set_text("Player 1 — press D to enter the shop.")
			transition.show()
			bg.show()
			await _wait_for_left()
		"right":
			bottom_text.set_text("Player 2 — press → to enter the shop.")
			transition.show()
			bg.show()
			await _wait_for_right()
	transition.hide()
	bg.hide()
	switched.emit("shop_" + player)

## `loser` is whoever lost pong and plays blackjack first.
func prompt_for_blackjack(loser: String) -> String:
	match loser:
		"left":
			bottom_text.set_text("Player 1 lost — you go first. Press D to start.")
			transition.show()
			await _wait_for_left()
			transition.hide()
			switched.emit("blackjack_left")
			return "left"
		"right":
			bottom_text.set_text("Player 2 lost — you go first. Press → to start.")
			transition.show()
			await _wait_for_right()
			transition.hide()
			switched.emit("blackjack_right")
			return "right"
	return ""

func prompt_for_plinko() -> void:
	bottom_text.set_text("Player 1 goes first. Press D to confirm.")
	transition.show()
	await _wait_for_left()
	transition.hide()
	switched.emit("plinko_left")

# ── Input helpers ─────────────────────────────────────────────────────────────
func _wait_for_left() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("left_attack"):
			return

func _wait_for_right() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("right_attack"):
			return
