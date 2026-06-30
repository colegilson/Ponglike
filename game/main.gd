# Game.gd
class_name Game
extends Node

# ── Scenes ──────────────────────────────────────────────────────────────────
@export var shop_scene:      PackedScene
@export var blackjack_scene: PackedScene
@export var plinko_scene:    PackedScene
@export var game_scene:      PackedScene

# ── Children ─────────────────────────────────────────────────────────────────
@onready var current:  Node2D         = $Pong
@onready var ui:       CanvasLayer    = $UI
@onready var music:    AudioStreamPlayer = $UI/AllButPong
@onready var ringo_L:  Node2D         = $UI/Ringo
@onready var ringo_R:  Node2D         = $UI/Ringo2
@onready var pause:    Node2D         = $Pause_start

# ── State ─────────────────────────────────────────────────────────────────────
enum Phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKOL, PLINKOR }

var round_number: int = 1
var l_used:       bool = false
var r_used:       bool = false

# ─────────────────────────────────────────────────────────────────────────────
func _ready() -> void:
	SaveData.current_phase = Phase.PONG
	SaveData.time_started  = Time.get_unix_time_from_system()
	current.game_won.connect(_on_pong_won)
	ui.switched.connect(_on_ui_switched)

func _process(__delta: float) -> void:
	if SaveData.current_phase != Phase.PONG and not music.playing:
		music.play()

# ── Pong ──────────────────────────────────────────────────────────────────────
func _on_pong_won(winner: String) -> void:
	SaveData.recent_winner = winner
	balance_update(winner, 5)
	current.game_won.disconnect(_on_pong_won)
	current.queue_free()

	if randi_range(0, 1) == 0:
		await transition_to_minigame(blackjack_scene, winner)
	else:
		await transition_to_minigame(plinko_scene, winner)

func start_pong_round() -> void:
	round_number += 1
	ringo_L.show()
	ui.find_child("Player1Coins").show()

	current = game_scene.instantiate()
	add_child(current)
	current.game_won.connect(_on_pong_won)

# ── Minigame transitions ──────────────────────────────────────────────────────
# `winner` is the pong winner; the *loser* plays the minigame first.
func transition_to_minigame(minigame: PackedScene, winner: String) -> void:
	var loser := "right" if winner == "left" else "left"

	current = minigame.instantiate()
	add_child.call_deferred(current)
	current.balance_update.connect(balance_update)

	if minigame == blackjack_scene:
		SaveData.current_phase = Phase.BLACKJACK
		ui.set_destination("Blackjack")
		current.set_process_input(false)
		var first: String = await ui.prompt_for_blackjack(loser)
		SaveData.current_user = first
		current.minigame_over.connect(_on_blackjack_over)

	elif minigame == plinko_scene:
		SaveData.current_phase = Phase.PLINKOL
		SaveData.current_user  = "left"
		ui.set_destination("Plinko")
		current.set_process_input(false)
		await ui.prompt_for_plinko()
		current.minigame_over.connect(_on_plinko_over)

func _on_ui_switched(string: String):
	if string == "blackjack_left" or string == "blackjack_right" or string == "plinko_left":
		current.set_process_input(true)

# ── Blackjack ─────────────────────────────────────────────────────────────────
func _on_blackjack_over(_result: String) -> void:
	current.minigame_over.disconnect(_on_blackjack_over)
	await transition_to_shop()

# ── Plinko ────────────────────────────────────────────────────────────────────
func _on_plinko_over(finished_player: String) -> void:
	if finished_player == "left":
		# Left side done — let right side play.
		SaveData.current_phase = Phase.PLINKOR
		SaveData.current_user  = "right"
		current.minigame_over.disconnect(_on_plinko_over)
		current.queue_free()
		current = plinko_scene.instantiate()
		add_child(current)
		current.minigame_over.connect(_on_plinko_over)
		current.balance_update.connect(balance_update)
		# The plinko scene itself should handle switching internally;
		# when right also finishes it will emit again with "right".
	else:
		# Both sides done.
		current.minigame_over.disconnect(_on_plinko_over)
		await transition_to_shop()

# ── Shop ──────────────────────────────────────────────────────────────────────
func transition_to_shop() -> void:
	current.queue_free()

	SaveData.current_phase = Phase.SHOPL
	SaveData.current_user  = "left"
	ui.set_destination("Shop")
	await ui.prompt_for_shop("left")

	_spawn_shop()

func _spawn_shop() -> void:
	current = shop_scene.instantiate()
	add_child(current)
	current.shop_done.connect(_on_shop_done)

func _on_shop_done(player: String) -> void:
	current.shop_done.disconnect(_on_shop_done)
	current.queue_free()

	match player:
			"left":
			#left player finished now right player shops.
				SaveData.current_phase = Phase.SHOPR
				SaveData.current_user  = "right"
				ui.set_destination("Shop")
				await ui.prompt_for_shop("right")
				_spawn_shop()

			"right":
			#both players done shopping back to pong.
				start_pong_round()

# ── Helpers ───────────────────────────────────────────────────────────────────
func balance_update(player: String, amount: int) -> void:
	var gaining := amount > 0
	match player:
		"left":
			if gaining and SaveData.lmoney_mult != 1:
				amount *= SaveData.lmoney_mult
			SaveData.money_left += amount
			ringo_L.forward_flip()
		"right":
			if gaining and SaveData.rmoney_mult != 1:
				amount *= SaveData.rmoney_mult
			SaveData.money_right += amount
			ringo_R.forward_flip()

func use_cig(player: String) -> void:
	if player == "left":
		l_used = true
	else:
		r_used = true

func print_all_in_inventory(player: String) -> void:
	var inventory: Array = (
		SaveData.ball_inventory_left if player == "left"
		else SaveData.ball_inventory_right
	)
	for ball in inventory:
		print(ball.name)
