extends Control

@onready var price: Label = $Buy/Price
@onready var desc: Label = $Desc
@onready var buy_button: Button = $Buy

@export var set_price: int = 100  # default price
@export var set_desc: String

var money: int = 500              # player starting money

func _ready() -> void:
	
	price.text ="Price: " + str(set_price) + "$"
	desc.text = str(set_desc)
	

func _on_buy_pressed() -> void:
	if SaveLoad.SaveFileData.money >= set_price:
		SaveLoad.SaveFileData.money -= set_price
		print("Item bought! Money left: ", SaveLoad.SaveFileData.money)
	else:
		print("Not enough money!")
