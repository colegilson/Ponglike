extends RefCounted
class_name SaveData
#Global 
static var money_left: int = 0
static var money_right: int = 0
static var lmoney_mult: int = 1
static var rmoney_mult: int = 1
#Blackjack:
static var current_user = "left" #left, right, or both depending on if pong, solo minigame, 2 player minigame (blackjack) or solo shops - will be used to display scene transitions
static var recent_winner: String = "left"
#Pong:
static var rounds_won_left = 0
static var rounds_won_right = 0
static var ball_inventory_left: Array[BallData] = [] 
static var ball_inventory_right: Array[BallData] = [] 
static var stick_inventory_left: Array[StickData] = [load("res://components/paddle/baseball_bat.tres"), load("res://components/paddle/snoopy.tres")] 
static var stick_inventory_right: Array[StickData] = [] 
static var current_stick: BallData
#Plinko
static var left_won = 0
static var right_won = 0
#States
enum phase {PONG, SHOPL, SHOPR, BLACKJACK, PLINKO} #maybe add plinko phases and check these conditions for bugfixing?
static var current_phase = phase.PONG
enum game_phase {L_RECEIVE, L_EMIT, R_RECEIVE, R_EMIT}
static var pong_phase = game_phase.L_RECEIVE
