extends Node

@export var delay: float = 1.0          # seconds between messages
@export var stop_index: int = 7         # the index where we pause (0-based)

var paused: bool = false
var current_index: int = 0
var continue_after_event: bool = false

func _ready() -> void:
	# Hide all messages first
	for child in get_children():
		child.visible = false
	
	# Start sequence
	show_children()


func show_children() -> void:
	_show_next_message()


func _show_next_message() -> void:
	if current_index >= get_child_count():
		return  # no more messages
	
	# Show current message
	var child = get_child(current_index)
	child.visible = true
	current_index += 1

	# Check if we reached stop point
	if current_index == stop_index and not continue_after_event:
		paused = true
		_trigger_event()
		return  # stop here until resumed

	# Otherwise continue automatically
	await get_tree().create_timer(delay).timeout
	_show_next_message()


func _trigger_event() -> void:
	# Do something special here
	print("Event triggered at message:", stop_index)
	# Example: play animation, show a choice, etc.
	# After the event finishes, call `resume_messages()`


func resume_messages() -> void:
	if paused:
		paused = false
		continue_after_event = true
		_show_next_message()
