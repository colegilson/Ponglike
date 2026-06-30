extends RefCounted
class_name SaveData
#Global 
static var money_left: int 
static var money_right: int
static var lmoney_mult: int = 1
static var rmoney_mult: int = 1
#Blackjack:
static var current_user = "left" #left, right, or both depending on if pong, solo minigame, 2 player minigame (blackjack) or solo shops - will be used to display scene transitions
static var recent_winner: String = "left"
static var left_river: bool = false
static var right_river: bool = false
static var cancel_river: bool = left_river and right_river
#Pong:
static var left_wins = 0
static var right_wins = 0
static var ball_inventory_left: Array[BallData] = [] 
static var ball_inventory_right: Array[BallData] = [] 
static var stick_inventory_left: Array[StickData] = [] 
static var stick_inventory_right: Array[StickData] = [] 
static var current_left_stick: StickData
static var current_left_ball: BallData
static var current_right_stick: StickData
static var current_right_ball: BallData
static var number_to_change = 1 #number of rounds to hold an effect for
static var l_cig_elapsed: float = 0.0
static var r_cig_elapsed: float = 0.0
static var ciggy_percent_l: float = 0.0
static var ciggy_percent_r: float = 0.0
#Plinko
static var left_won = 0
static var right_won = 0
#States
enum phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKOL, PLINKOR } #maybe add plinko phases and check these conditions for bugfixing?
enum state { L_RECEIVE, L_EMIT, R_RECEIVE, R_EMIT }
static var current_phase = phase.PONG
static var current_state = state.L_RECEIVE
static var time_started
#Shop
static var shop_queue_left_ball: Array[BallData] = [] 
static var shop_queue_right_ball: Array[BallData] = [] 
static var shop_queue_left_stick: Array[StickData] = [] 
static var shop_queue_right_stick: Array[StickData] = []
static var shop_queues_done = false
static var shop_casino_left: bool = false
static var shop_casino_right: bool = false
