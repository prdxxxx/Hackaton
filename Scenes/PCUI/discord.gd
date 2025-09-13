extends Control
@onready var discord: Control = $"."
@onready var guide: ScrollContainer = $WindowBase/Chat/Guide
@onready var anon: ScrollContainer = $WindowBase/Chat/Anon
@onready var anon_contact: Panel = $WindowBase/Contacts/ScrollContainer/VBoxContainer/Anon_contact


func _ready() -> void:
	guide.show()
	anon.hide()

func _on_exit_pressed() -> void:
	discord.hide()


func _on_guide_button_pressed() -> void:
	guide.show()
	anon.hide()


func _on_anon_button_pressed() -> void:
	guide.hide()
	anon.show()
