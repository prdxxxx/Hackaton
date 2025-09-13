extends Control
@onready var acc = $"."
@onready var bankclient1 = $BankClient1
@onready var enter_2: Button = $WindowBase/AccountsPanel/PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer2/Enter2
@onready var bank_client_2: Control = $BankClient2
@onready var bank_client_3: Control = $BankClient3
@onready var bank_client_4: Control = $BankClient4

func _on_logout_button_pressed() -> void:
	acc.hide()
	


func _on_enter_1_pressed() -> void:
	bankclient1.show()


func _on_enter_2_pressed() -> void:
	bank_client_2.show()


func _on_enter_3_pressed() -> void:
	bank_client_3.show()


func _on_enter_4_pressed() -> void:
	bank_client_4.show()
