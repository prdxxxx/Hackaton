extends Control
@onready var acc = $"."
@onready var bankclient1 = $BankClient1

func _on_logout_button_pressed() -> void:
	acc.hide()
	


func _on_enter_1_pressed() -> void:
	bankclient1.show()
