extends Panel
@onready var acc = $"."

func _on_logout_button_pressed() -> void:
	acc.hide()
	
