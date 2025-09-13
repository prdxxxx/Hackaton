extends Control

@export var GrabThreshold := 50
@export var ResizeThreshold := 20
@export var MinSize := Vector2(300, 200)
@export var CenterOnShow := true

var start: Vector2
var initialPosition: Vector2
var initialSize: Vector2 = Vector2.ZERO

var isMoving := false
var isResizing := false
var resizeLeft := false
var resizeRight := false
var resizeTop := false
var resizeBottom := false

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
		_handle_mouse_motion()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_handle_mouse_press(mouse_pos)
		else:
			_handle_mouse_release()

func _handle_mouse_press(mouse_pos: Vector2) -> void:
	var local_pos = mouse_pos - get_global_position()

	# Перетаскивание окна
	if local_pos.y < GrabThreshold:
		start = mouse_pos
		initialPosition = position
		isMoving = true
		return

	# Сброс флагов
	isResizing = false
	resizeLeft = false
	resizeRight = false
	resizeTop = false
	resizeBottom = false
	initialSize = size
	initialPosition = position
	start = mouse_pos

	# Горизонтальный ресайз
	if local_pos.x < ResizeThreshold:
		resizeLeft = true
		isResizing = true
	elif local_pos.x > size.x - ResizeThreshold:
		resizeRight = true
		isResizing = true

	# Вертикальный ресайз
	if local_pos.y < ResizeThreshold:
		resizeTop = true
		isResizing = true
	elif local_pos.y > size.y - ResizeThreshold:
		resizeBottom = true
		isResizing = true

func _handle_mouse_motion() -> void:
	if isMoving:
		position = initialPosition + (get_global_mouse_position() - start)

	if isResizing:
		var delta = get_global_mouse_position() - start
		var new_size = initialSize
		var new_pos = initialPosition

		# Горизонталь
		if resizeLeft:
			new_size.x = max(MinSize.x, initialSize.x - delta.x)
			new_pos.x = initialPosition.x + (initialSize.x - new_size.x)
		elif resizeRight:
			new_size.x = max(MinSize.x, initialSize.x + delta.x)

		# Вертикаль
		if resizeTop:
			new_size.y = max(MinSize.y, initialSize.y - delta.y)
			new_pos.y = initialPosition.y + (initialSize.y - new_size.y)
		elif resizeBottom:
			new_size.y = max(MinSize.y, initialSize.y + delta.y)

		position = new_pos
		size = new_size

func _handle_mouse_release() -> void:
	isMoving = false
	isResizing = false
	resizeLeft = false
	resizeRight = false
	resizeTop = false
	resizeBottom = false

func _update_cursor(mouse_pos: Vector2):
	var rect = get_global_rect()
	var cursor = Input.CURSOR_ARROW

	if mouse_pos.x >= rect.position.x + size.x - ResizeThreshold and mouse_pos.y >= rect.position.y + size.y - ResizeThreshold:
		cursor = Input.CURSOR_FDIAGSIZE
	elif mouse_pos.x <= rect.position.x + ResizeThreshold and mouse_pos.y >= rect.position.y + size.y - ResizeThreshold:
		cursor = Input.CURSOR_BDIAGSIZE
	elif mouse_pos.x <= rect.position.x + ResizeThreshold or mouse_pos.x >= rect.position.x + size.x - ResizeThreshold:
		cursor = Input.CURSOR_HSIZE
	elif mouse_pos.y <= rect.position.y + ResizeThreshold or mouse_pos.y >= rect.position.y + size.y - ResizeThreshold:
		cursor = Input.CURSOR_VSIZE
	elif mouse_pos.y <= rect.position.y + GrabThreshold:
		cursor = Input.CURSOR_POINTING_HAND

	if cursor != current_cursor:
		current_cursor = cursor
		Input.set_default_cursor_shape(current_cursor)

func _on_visibility_changed():
	if visible:
		_handle_mouse_release()
		if CenterOnShow:
			var vp = get_viewport_rect().size
			position = (vp - size) / 2

func _on_exit_pressed() -> void:
	hide()
