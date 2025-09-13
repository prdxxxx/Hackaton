extends Control

@export var GrabThreshold := 50
@export var ResizeThreshold := 30
@export var MinSize := Vector2(300, 200)
@export var CenterOnShow := true

var start: Vector2
var initialPosition: Vector2
var initialSize: Vector2 = Vector2.ZERO

var isMoving := false
var isResizing := false
var resizeX := false
var resizeY := false

var current_cursor = null

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _input(event):
	if not visible:
		return

	var mouse_pos = get_global_mouse_position()
	var rect = get_global_rect()

	if not rect.has_point(mouse_pos) and not isMoving and not isResizing:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		return

	if event is InputEventMouseMotion:
		_update_cursor(mouse_pos)
		_handle_mouse_motion(event)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_handle_mouse_press(event)
		else:
			_handle_mouse_release()

func _handle_mouse_press(event: InputEventMouseButton) -> void:
	var localMousePos = event.position - get_global_position()

	# Перетаскивание окна
	if localMousePos.y < GrabThreshold:
		start = get_global_mouse_position()
		initialPosition = get_global_position()
		isMoving = true
		return

	# Ресайз по X
	if localMousePos.x < ResizeThreshold or localMousePos.x > size.x - ResizeThreshold:
		start = get_global_mouse_position()
		initialSize = size
		isResizing = true
		resizeX = true

	# Ресайз по Y
	if localMousePos.y < ResizeThreshold or localMousePos.y > size.y - ResizeThreshold:
		start = get_global_mouse_position()
		initialSize = size
		isResizing = true
		resizeY = true

func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if isMoving:
		position = initialPosition + (get_global_mouse_position() - start)

	if isResizing:
		var diff = get_global_mouse_position() - start
		var new_size = initialSize

		if resizeX:
			new_size.x += diff.x
		if resizeY:
			new_size.y += diff.y

		new_size.x = max(MinSize.x, new_size.x)
		new_size.y = max(MinSize.y, new_size.y)

		size = new_size  # применяем размер окна

func _handle_mouse_release():
	isMoving = false
	isResizing = false
	resizeX = false
	resizeY = false

func _update_cursor(mouse_pos: Vector2):
	var rect = get_global_rect()
	var cursor_shape = Input.CURSOR_ARROW

	if mouse_pos.x >= rect.position.x + size.x - ResizeThreshold and mouse_pos.y >= rect.position.y + size.y - ResizeThreshold:
		cursor_shape = Input.CURSOR_FDIAGSIZE
	elif mouse_pos.x <= rect.position.x + ResizeThreshold and mouse_pos.y >= rect.position.y + size.y - ResizeThreshold:
		cursor_shape = Input.CURSOR_BDIAGSIZE
	elif mouse_pos.x >= rect.position.x + size.x - ResizeThreshold or mouse_pos.x <= rect.position.x + ResizeThreshold:
		cursor_shape = Input.CURSOR_HSIZE
	elif mouse_pos.y >= rect.position.y + size.y - ResizeThreshold or mouse_pos.y <= ResizeThreshold:
		cursor_shape = Input.CURSOR_VSIZE
	elif mouse_pos.y <= rect.position.y + GrabThreshold:
		cursor_shape = Input.CURSOR_POINTING_HAND

	if cursor_shape != current_cursor:
		current_cursor = cursor_shape
		Input.set_default_cursor_shape(current_cursor)

func _on_visibility_changed():
	if visible:
		_handle_mouse_release()
		if CenterOnShow:
			var viewport_size = get_viewport_rect().size
			position = (viewport_size - size) / 2

func _on_exit_pressed() -> void:
	hide()
