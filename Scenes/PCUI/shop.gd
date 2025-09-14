extends Control

@onready var shop: Control = $"."

@onready var balance: Label = $WindowBase/Balance

@onready var v_box_container: VBoxContainer = $WindowBase/ScrollContainer/VBoxContainer/HBoxContainer/VBoxContainer
@onready var v_box_container_2: VBoxContainer = $WindowBase/ScrollContainer/VBoxContainer/HBoxContainer/VBoxContainer2
@onready var v_box_container_3: VBoxContainer = $WindowBase/ScrollContainer/VBoxContainer/HBoxContainer/VBoxContainer3
@onready var v_box_container_4: VBoxContainer = $WindowBase/ScrollContainer/VBoxContainer/HBoxContainer2/VBoxContainer4
@onready var v_box_container_5: VBoxContainer = $WindowBase/ScrollContainer/VBoxContainer/HBoxContainer2/VBoxContainer5
@onready var v_box_container_6: VBoxContainer = $WindowBase/ScrollContainer/VBoxContainer/HBoxContainer2/VBoxContainer6
@onready var v_box_container_7: VBoxContainer = $WindowBase/ScrollContainer/VBoxContainer/HBoxContainer3/VBoxContainer7

@onready var h_box_container: HBoxContainer = $WindowBase/ScrollContainer/VBoxContainer/HBoxContainer
@onready var h_box_container_2: HBoxContainer = $WindowBase/ScrollContainer/VBoxContainer/HBoxContainer2
@onready var h_box_container_3: HBoxContainer = $WindowBase/ScrollContainer/VBoxContainer/HBoxContainer3

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer



func _ready() -> void:
	v_box_container.visible = !SaveLoad.SaveFileData.world_obj["Sofa1"]
	v_box_container_2.visible = !SaveLoad.SaveFileData.world_obj["Sofa2"]
	v_box_container_3.visible = !SaveLoad.SaveFileData.world_obj["Sofa3"]
	v_box_container_4.visible = !SaveLoad.SaveFileData.world_obj["Minecraft"]
	v_box_container_5.visible = !SaveLoad.SaveFileData.world_obj["Roblox"]
	v_box_container_6.visible = !SaveLoad.SaveFileData.world_obj["tv"]
	v_box_container_7.visible = !SaveLoad.SaveFileData.world_obj["Antenna"]

func _process(delta: float) -> void:
	balance.text ="Balance: "+ str(SaveLoad.SaveFileData.money) + "$"
	check()
	
func _on_exit_pressed() -> void:
	shop.hide()
	
func check() -> void:
	if SaveLoad.SaveFileData.world_obj["Sofa1"] == true \
	and SaveLoad.SaveFileData.world_obj["Sofa2"] == true \
	and SaveLoad.SaveFileData.world_obj["Sofa3"] == true:
		h_box_container.hide()

	if SaveLoad.SaveFileData.world_obj["Minecraft"] == true \
	and SaveLoad.SaveFileData.world_obj["Roblox"] == true \
	and SaveLoad.SaveFileData.world_obj["tv"] == true:
		h_box_container_2.hide()

	if SaveLoad.SaveFileData.world_obj["Antenna"] == true:
		h_box_container_3.hide()


func _on_sofa_1_button_pressed() -> void:
	v_box_container.hide()
	SaveLoad.SaveFileData.world_obj["Sofa1"] = !SaveLoad.SaveFileData.world_obj["Sofa1"]
	audio_stream_player.play()
func _on_sofa_2_button_pressed() -> void:
	v_box_container_2.hide()
	SaveLoad.SaveFileData.world_obj["Sofa2"] = !SaveLoad.SaveFileData.world_obj["Sofa2"]
	audio_stream_player.play()
func _on_sofa_3_button_pressed() -> void:
	v_box_container_3.hide()
	SaveLoad.SaveFileData.world_obj["Sofa3"] = !SaveLoad.SaveFileData.world_obj["Sofa3"]
	audio_stream_player.play()
func _on_minecraft_button_pressed() -> void:
	v_box_container_4.hide()
	SaveLoad.SaveFileData.world_obj["Minecraft"] = !SaveLoad.SaveFileData.world_obj["Minecraft"]
	audio_stream_player.play()
func _on_roblox_button_pressed() -> void:
	v_box_container_5.hide()
	SaveLoad.SaveFileData.world_obj["Roblox"] = !SaveLoad.SaveFileData.world_obj["Roblox"]
	audio_stream_player.play()
func _on_smart_tv_button_pressed() -> void:
	v_box_container_6.hide()
	SaveLoad.SaveFileData.world_obj["tv"] = !SaveLoad.SaveFileData.world_obj["tv"]
	audio_stream_player.play()
func _on_antenna_button_pressed() -> void:
	v_box_container_7.hide()
	SaveLoad.SaveFileData.world_obj["Antenna"] = !SaveLoad.SaveFileData.world_obj["Antenna"]
	audio_stream_player.play()
