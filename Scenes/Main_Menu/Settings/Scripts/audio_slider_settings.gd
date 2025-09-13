extends Control

@onready var audio_name: Label = $HBoxContainer/Audio_Name
@onready var audio_num: Label = $HBoxContainer/Audio_Num
@onready var h_slider: HSlider = $HBoxContainer/HSlider

@export_enum("Master", "Music", "SFX") var bus_name : String

func _ready() -> void:
	h_slider.connect("value_changed", Callable(self, "on_value_changed"))
	set_name_label_text()
	set_slider_value()

func set_name_label_text() -> void:
	audio_name.text = bus_name + " Volume"

func set_audio_num_label_text() -> void:
	audio_num.text = str(round(h_slider.value * 100)) + "%"

func set_slider_value() -> void:
	# Use AudioManager's saved value
	h_slider.value = AudioManager.get_volume(bus_name)
	set_audio_num_label_text()

func on_value_changed(value: float) -> void:
	AudioManager.set_volume(bus_name, value)
	set_audio_num_label_text()
