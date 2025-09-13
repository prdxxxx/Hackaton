extends Control
@onready var bank_client_2: Control = $"."
@onready var exit: Button = $WindowBase/PanelContainer/Exit
@onready var _2fa: Control = $"2FA"


func _on_exit_pressed() -> void:
	bank_client_2.hide()


func _on_button_pressed() -> void:
	_2fa.show()
