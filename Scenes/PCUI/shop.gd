extends Control

@onready var shop: Control = $"."

@onready var balance: Label = $WindowBase/Balance

func _process(delta: float) -> void:
	balance.text ="Balance: "+ str(SaveLoad.SaveFileData.money) + "$"



func _on_exit_pressed() -> void:
	shop.hide()
