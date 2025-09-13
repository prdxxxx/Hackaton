extends Control
@onready var ettercap = $"."
@onready var scan = $ScanNet
@onready var mitm = $MITM

func _on_exit_button_pressed() -> void:
	ettercap.hide()
	


func _on_scan_button_pressed() -> void:
	scan.show()

func _ready():
	$WindowBase/PanelContainer/VBoxContainer/ScanButton.add_to_group("scan_buttons")


func _on_mitm_button_pressed() -> void:
	mitm.show()
