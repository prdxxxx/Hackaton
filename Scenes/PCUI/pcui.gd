extends Control
@onready var buttons_container: Button = $ButtonsCont as Button
@onready var cmd: Control = $CMD as Control
@onready var helpText = $Help_UI/Help_Text
@onready var aircrack: Control = $AirCreck as Control
@onready var ettercap: Control = $EtterCap as Control
@onready var notepad: Control = $Notepad as Control
@onready var discord: Control = $Discord
@onready var browser: Control = $LoginSite
@onready var shop: Control = $Shop
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"
@onready var click: AudioStreamPlayer2D = $"../click"


func _input(event):
	if event.is_action_pressed("Zoom"):
		queue_free()                   # закрыть UI
		get_tree().paused = false      # снять паузу
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _ready() -> void:
	if not Events.ui_sound_played:
		audio_stream_player_2d.play()
		Events.ui_sound_played = true
	Events.connect("aircrack_command", Callable(self, "_on_aircrack_pressed"))
	PcManager.ui_active = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	
func _exit_tree():
	PcManager.ui_active = false  # разблокируем камеру при выходе


func _on_cmd_pressed() -> void:
	cmd.show()
	click.play()

func _on_power_button_pressed() -> void:
	show_help_text("Press 'Ctrl' key for shutdown", 3.0)
	click.play()
	pass

func show_help_text(customText: String, duration:float):#!!!Cand este prea mult text folositi: \n
	helpText.text = customText
	helpText.show()
	var timer = get_tree().create_timer(duration)
	await timer.timeout
	helpText.hide()


func _on_aircrack_pressed() -> void:
	aircrack.show()
	click.play()


func _on_etter_cap_pressed() -> void:
	ettercap.show()
	click.play()


func _on_notepad_pressed() -> void:
	notepad.show()
	click.play()


func _on_discord_pressed() -> void:
	click.play()
	discord.show()
	var msg_node = discord.get_node("WindowBase/Chat/Guide/VBoxContainer") 
	msg_node.show_children()



func _on_btowser_pressed() -> void:
	browser.show()
	click.play()


func _on_e_shop_pressed() -> void:
	shop.show()
	click.play()
