extends Control

signal cancel_threat_call
signal wrong_choice

func _on_button_2_pressed() -> void:
	cancel_threat_call.emit()


func _on_button_pressed() -> void:
	wrong_choice.emit()
