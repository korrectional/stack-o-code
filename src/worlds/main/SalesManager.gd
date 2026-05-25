extends Node

var gold = 0;

func legalDockSell(item):
	var fishValue: int = 0
	match item.fish_stats.get_fish_type():
		"Salmon":
			fishValue = 30
		"Tuna":
			fishValue = 20
		"Swordfish":
			fishValue = 40
	fishValue *= item.fish_stats.weight
	gold += fishValue
