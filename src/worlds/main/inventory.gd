extends Control

const ITEM_SLOT = preload("uid://cqfbsoptuymx2")
@onready var trading_panel: Panel = $tradingPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(Global.itemSlotsUnlocked):
		var newItem = ITEM_SLOT.instantiate()
		get_child(0).add_child(newItem)
		newItem.position = Vector2(15 + 65*(i),15)

@onready var goldLabel: Label = $gold
func _process(_delta: float) -> void:
	if visible:
		goldLabel.text = str(SalesManager.gold)
		if Global.insideLegalDock: # this is more expensive to check so its separate
			trading_panel.visible = true
		elif trading_panel.visible:
			trading_panel.visible = false
