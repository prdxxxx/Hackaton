extends Control


@onready var option_button: OptionButton = $HBoxContainer/OptionButton as OptionButton


const RESOLUTION_DICTIONARY : Dictionary = {
	"2560 X 1440" : Vector2i(2560, 1440),
	"1920 x 1080" : Vector2i(1920, 1080),
	"1280 x 720" : Vector2i(1280, 720),
	"854 x 480" : Vector2i(854, 480)
}

func _ready() -> void:
	option_button.item_selected.connect(on_resolution_selected)
	add_resolution_items()

func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)



func on_resolution_selected(index : int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	
