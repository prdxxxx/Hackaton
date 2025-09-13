extends Control
@onready var accept: Button = $Accept
@onready var cancel: Button = $Cancel

@onready var label_4: Label = $Label4
@onready var label_5: Label = $Label5

signal cancel_threat_call

func _process(delta: float) -> void:
	if accept.is_hovered():
		label_5.show()
		label_4.hide()

	elif cancel.is_hovered():
		label_4.show()
		label_5.hide()

func _on_button_2_pressed() -> void:
	cancel_threat_call.emit()
