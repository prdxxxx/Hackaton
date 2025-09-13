extends Node3D

@onready var lights_walls: Node3D = $"../../ElectricBox/Lights/Lights_Walls"

# Звук переключателя
@onready var switch_sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D

var onoff: bool = false

func _ready() -> void:
	SaveLoad._load()
	onoff = SaveLoad.SaveFileData.lights_walls

	$off.visible = onoff
	$on.visible = !onoff
	lights_walls.visible = onoff

func toggle_light() -> void:
	# Переключаем свет
	onoff = !onoff
	$off.visible = onoff
	$on.visible = !onoff
	lights_walls.visible = onoff
	SaveLoad.SaveFileData.lights_walls = onoff

	# Проигрываем звук свитча
	if switch_sfx:
		switch_sfx.play()
