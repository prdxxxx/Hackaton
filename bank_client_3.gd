extends Control
@onready var exit: Button = $WindowBase/PanelContainer/Exit
@onready var button: Button = $WindowBase/PanelContainer/VBoxContainer/Label/Button
@onready var bank_client_3: Control = $"."
@onready var _2fa: Control = $"2FA"


func _on_button_pressed() -> void:
	_2fa.show()
	
	


func _on_exit_pressed() -> void:
	bank_client_3.hide()
