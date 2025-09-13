extends Control
@onready var auth = $"2FA"

func _on_button_pressed() -> void:
	auth.show()
