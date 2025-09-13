extends Control

@onready var price: Label = $Buy/Price
@onready var desc: Label = $Desc
@onready var buy_button: Button = $Buy
@onready var shop_product: Control = $"."
@onready var warning: Label = $"../../../../../Warning"

@export var set_price: int = 100  # default price
@export var set_desc: String
@export var prod_name:String

var money: int = 500              # player starting money

signal button_pressed

func _ready() -> void:
	
	price.text ="Price: " + str(set_price) + "$"
	desc.text = str(set_desc)
	shop_product.name = prod_name


func _on_buy_pressed() -> void:
	if SaveLoad.SaveFileData.money >= set_price:
		SaveLoad.SaveFileData.money -= set_price
		button_pressed.emit()
		SaveLoad._save()
	else:
		warning.show()
		
