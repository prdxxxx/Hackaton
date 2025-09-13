extends Node3D

@onready var lights_storage: Node3D = $"../../ElectricBox/Lights/Lights_Storage"

# Audio для этой группы ламп
@onready var lamp_sfx: AudioStreamPlayer3D = $"../../ElectricBox/Lights/Lights_Storage/Lights"  # AudioStreamPlayer3D в сцене
@onready var switch_sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D  # добавляем отдельный звук для свитча

var onoff: bool = false

func _ready() -> void:
	SaveLoad._load()
	onoff = SaveLoad.SaveFileData.lights_storage
	
	$off.visible = onoff
	$on.visible = !onoff
	lights_storage.visible = onoff

	# Воспроизводим или останавливаем звук при старте сцены
	_update_lamp_sound()

func toggle_light() -> void:
	# Переключаем свет
	onoff = !onoff
	$off.visible = onoff
	$on.visible = !onoff
	lights_storage.visible = onoff
	SaveLoad.SaveFileData.lights_storage = onoff

	# Включаем или выключаем звук ламп
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
