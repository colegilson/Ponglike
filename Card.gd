extends Node
class_name Card

# Class variables
var suite: String = ""
var value: int = 0

func _init(card_suite: String, card_value: int):
	suite = card_suite
	value = card_value
	
func get_png(card: Card) -> String:
	return "%s_%d.png" % [card.suite, card.value]
