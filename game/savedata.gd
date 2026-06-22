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
static var stick_inventory_left: Array[StickData] = [] 
static var stick_inventory_right: Array[StickData] = [] 
static var current_stick: BallData
#Plinko
static var left_won = 0
static var right_won = 0
#States
enum phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKO } #maybe add plinko phases and check these conditions for bugfixing?
enum state { L_RECEIVE, L_EMIT, R_RECEIVE, R_EMIT }
static var current_phase = phase.PONG
static var pong_phase = state.L_RECEIVE
#Shop
static var shop_queue_left_ball: Array[BallData] = [] 
static var shop_queue_right_ball: Array[BallData] = [] 
static var shop_queue_left_stick: Array[StickData] = [] 
static var shop_queue_right_stick: Array[StickData] = []
static var shop_queues_done = false
