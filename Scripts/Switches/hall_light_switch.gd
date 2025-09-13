extends Node3D

@onready var lights_hall: Node3D = $"../../ElectricBox/Lights/Lights_Hall"
@onready var lights_hall_2: Node3D = $"../../ElectricBox/Lights/Lights_Hall2"

# Audio для этой группы ламп
@onready var lamp_sfx: AudioStreamPlayer3D = $"../../ElectricBox/Lights/Lights_Hall/Lights"  # AudioStreamPlayer3D в сцене
@onready var switch_sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D  # звук для переключателя

var onoff: bool = false

func _ready() -> void:
	SaveLoad._load()
	onoff = SaveLoad.SaveFileData.lights_hall
	
	$off.visible = onoff
	$on.visible = !onoff
	lights_hall.visible = onoff
	lights_hall_2.visible = onoff

	# Воспроизводим или останавливаем звук при старте сцены
	_update_lamp_sound()

func toggle_light() -> void:
	# Переключаем свет
	onoff = !onoff
	$off.visible = onoff
	$on.visible = !onoff
	lights_hall.visible = onoff
	lights_hall_2.visible = onoff
	SaveLoad.SaveFileData.lights_hall = onoff

	# Управляем звуком ламп
	_update_lamp_sound()

	# Проигрываем звук свитча
	if switch_sfx:
		switch_sfx.play()

# -------------------- Вспомогательная функция --------------------
func _update_lamp_sound() -> void:
	if lamp_sfx:
		if onoff:
			if not lamp_sfx.playing:
				lamp_sfx.play()
		else:
			if lamp_sfx.playing:
				lamp_sfx.stop()
