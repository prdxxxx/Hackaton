extends Control
@onready var bank_client_4: Control = $"."
@onready var exit: Button = $WindowBase/PanelContainer/Exit
@onready var _2fa: Control = $"2FA"


func _on_exit_pressed() -> void:
	bank_client_4.hide()


func _on_button_pressed() -> void:
	_2fa.show()
