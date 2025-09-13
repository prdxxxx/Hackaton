extends Control
@onready var auth = $"2FA"
@onready var client = $"."

func _on_button_pressed() -> void:
	auth.show()


func _on_exit_pressed() -> void:
	client.hide()
