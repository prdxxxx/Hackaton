extends Node

@export var delay: float = 5.0          # seconds between messages
@export var stop_index: int = 6         # the index where we pause (0-based)
@export var messages_after_call: int = 2 # how many messages to show after call automatically

@onready var discord_call: Control = $"../../../Discord_Call"
@onready var anon_contact: Panel = $"../../../Contacts/ScrollContainer/VBoxContainer/Anon_contact"
@onready var guide: ScrollContainer = $".."
@onready var audio_stream_player: AudioStreamPlayer = $"../../../../AudioStreamPlayer"

@onready var scrollbar = guide.get_v_scroll_bar()


var paused: bool = false
var current_index: int = 0
var continue_after_event: bool = false

func _ready() -> void:
	scrollbar.changed.connect(handle_scrollbar_changed)

	for child in get_children():
		child.visible = false

func handle_scrollbar_changed():
	guide.scroll_vertical = scrollbar.max_value

func show_children() -> void:
	_show_next_message()

func _show_next_message() -> void:
	if current_index >= get_child_count():
		return  # no more messages

	# Show current message
	var child = get_child(current_index)
	child.visible = true
	audio_stream_player.play()
	current_index += 1
	

	# Check if we reached stop point
	if current_index == stop_index and not continue_after_event:
		paused = true
		_trigger_event()

		# Show next N messages automatically
		for i in range(messages_after_call):
			if current_index >= get_child_count():
				break
			await get_tree().create_timer(delay).timeout
			var next_child = get_child(current_index)
			next_child.visible = true
			audio_stream_player.play()
			current_index += 1

		return  # stop here until resumed

	# Otherwise continue automatically
	await get_tree().create_timer(delay).timeout
	_show_next_message()

func _trigger_event() -> void:
	discord_call.show()
	anon_contact.show()

func resume_messages() -> void:
	if paused:
		paused = false
		continue_after_event = true
		_show_next_message()
  
func _on_discord_call_cancel_threat_call() -> void:
	discord_call.hide()
	resume_messages()
