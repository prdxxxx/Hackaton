extends Control
@onready var discord: Control = $"."
@onready var guide: ScrollContainer = $WindowBase/Chat/Guide
@onready var anon: ScrollContainer = $WindowBase/Chat/Anon
@onready var anon_contact: Panel = $WindowBase/Contacts/ScrollContainer/VBoxContainer/Anon_contact
@onready var anon_button: Button = $WindowBase/Contacts/ScrollContainer/VBoxContainer/Anon_contact/Anon_Button
@onready var block_button: Button = $WindowBase/Contacts/ScrollContainer/VBoxContainer/Anon_contact/block_button
@onready var label: Label = $WindowBase/Contacts/ScrollContainer/VBoxContainer/Anon_contact/block_button/Label


@export var discord_open: bool 

signal anon_on


func _ready() -> void:
	guide.show()
	anon.hide()
	anon_contact.hide()

func _process(delta: float) -> void:
	if anon_button.is_hovered() or block_button.is_hovered():
		block_button.show()
		if block_button.is_hovered():
			label.show()
		else:
			label.hide()
	else:
		block_button.hide()
		label.hide()

func _on_exit_pressed() -> void:
	discord.hide()


func _on_guide_button_pressed() -> void:
	guide.show()
	anon.hide()


func _on_anon_button_pressed() -> void:
	guide.hide()
	anon.show()
	anon_on.emit()


func _on_block_button_pressed() -> void:
	guide.show()
	anon.hide()
	anon_contact.hide()
