extends RefCounted
class_name SaveData
#Global 
static var money_left: int = 0
static var money_right: int = 0
#Blackjack:
static var current_user = "left" #left, right, or both depending on if pong, solo minigame, 2 player minigame (blackjack) or solo shops - will be used to display scene transitions
static var recent_winner: String = "left"
#Pong:
static var rounds_won_left = 0
static var rounds_won_right = 0
static var ball_inventory_left: Array[BallData] = [] 
static var ball_inventory_right: Array[BallData] = [] 
