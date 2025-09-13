extends Control

@onready var text_edit: TextEdit = $WindowBase/Panel/TextEdit
@onready var desktop_txt: Control = $"."

var stored_text: String = SaveLoad.SaveFileData.desktop_txt

func _ready() -> void:
	stored_text = SaveLoad.SaveFileData.desktop_txt
	text_edit.text = stored_text

func _on_text_edit_text_changed() -> void:
	stored_text = text_edit.text
	SaveLoad.SaveFileData.desktop_txt = stored_text


func _on_button_pressed() -> void:
	desktop_txt.hide()
