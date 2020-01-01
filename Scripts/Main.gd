extends Node


onready var _tello := $Tello as Tello


var _speed := 100
var _distance := 20
var _turn_angle := 1
var _rc_mode := false setget update_rc_mode
var _rc_mode_started := false


func _ready() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 14, OS.get_ticks_usec(), '')
	$Start.visible = true
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 15, OS.get_ticks_usec(), '	$Start.visible = true')


func _process(_delta: float) -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 18, OS.get_ticks_usec(), '')
	if !_rc_mode:
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 19, OS.get_ticks_usec(), '	if !_rc_mode:')
		return
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 20, OS.get_ticks_usec(), '')
	if Input.is_action_just_pressed("emergency"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 21, OS.get_ticks_usec(), '	if Input.is_action_just_pressed("emergency"):')
		_tello.emergency()
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 22, OS.get_ticks_usec(), '		_tello.emergency()')
		_rc_mode = false
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 23, OS.get_ticks_usec(), '		_rc_mode = false')
		_rc_mode_started = false
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 24, OS.get_ticks_usec(), '		_rc_mode_started = false')
		$DebugStuff/Box/Box/RC.pressed = false
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 25, OS.get_ticks_usec(), '		$DebugStuff/Box/Box/RC.pressed = false')
		return
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 26, OS.get_ticks_usec(), '')
	if Input.is_action_just_pressed("takeoff"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 27, OS.get_ticks_usec(), '	if Input.is_action_just_pressed("takeoff"):')
		_tello.takeoff()
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 28, OS.get_ticks_usec(), '		_tello.takeoff()')
		_rc_mode_started = true
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 29, OS.get_ticks_usec(), '		_rc_mode_started = true')
		return
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 30, OS.get_ticks_usec(), '')
	if Input.is_action_just_pressed("land"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 31, OS.get_ticks_usec(), '	if Input.is_action_just_pressed("land"):')
		_tello.land()
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 32, OS.get_ticks_usec(), '		_tello.land()')
		_rc_mode = false
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 33, OS.get_ticks_usec(), '		_rc_mode = false')
		_rc_mode_started = false
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 34, OS.get_ticks_usec(), '		_rc_mode_started = false')
		$DebugStuff/Box/Box/RC.pressed = false
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 35, OS.get_ticks_usec(), '		$DebugStuff/Box/Box/RC.pressed = false')
		return
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 36, OS.get_ticks_usec(), '')
	_handle_rc_control()
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 37, OS.get_ticks_usec(), '	_handle_rc_control()')


func _handle_rc_control() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 40, OS.get_ticks_usec(), '')
	if !_rc_mode_started:
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 41, OS.get_ticks_usec(), '	if !_rc_mode_started:')
		return
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 42, OS.get_ticks_usec(), '')
	var forward_backward := _input_forward_back()
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 43, OS.get_ticks_usec(), '	var forward_backward := _input_forward_back()')
	var left_right := _input_left_right()
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 44, OS.get_ticks_usec(), '	var left_right := _input_left_right()')
	var yaw := _input_turn_left_right()
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 45, OS.get_ticks_usec(), '	var yaw := _input_turn_left_right()')
	var up_down := _input_up_down()
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 46, OS.get_ticks_usec(), '	var up_down := _input_up_down()')
	_tello.rc(left_right * _speed, forward_backward * _speed, up_down * _speed, yaw * _speed)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 47, OS.get_ticks_usec(), '	_tello.rc(left_right * _speed, forward_backward * _speed, up_down * _speed, yaw * _speed)')


func _input_up_down() -> int:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 50, OS.get_ticks_usec(), '')
	var up_down := 0
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 51, OS.get_ticks_usec(), '	var up_down := 0')
	if Input.is_action_pressed("up"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 52, OS.get_ticks_usec(), '	if Input.is_action_pressed("up"):')
		up_down += 1
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 53, OS.get_ticks_usec(), '		up_down += 1')
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 53, OS.get_ticks_usec(), '')
	if Input.is_action_pressed("down"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 54, OS.get_ticks_usec(), '	if Input.is_action_pressed("down"):')
		up_down += -1
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 55, OS.get_ticks_usec(), '		up_down += -1')
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 55, OS.get_ticks_usec(), '')
	return up_down


func _input_turn_left_right() -> int:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 59, OS.get_ticks_usec(), '')
	var yaw := 0
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 60, OS.get_ticks_usec(), '	var yaw := 0')
	if Input.is_action_pressed("turn_left"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 61, OS.get_ticks_usec(), '	if Input.is_action_pressed("turn_left"):')
		yaw += -1
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 62, OS.get_ticks_usec(), '		yaw += -1')
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 62, OS.get_ticks_usec(), '')
	if Input.is_action_pressed("turn_right"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 63, OS.get_ticks_usec(), '	if Input.is_action_pressed("turn_right"):')
		yaw += 1
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 64, OS.get_ticks_usec(), '		yaw += 1')
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 64, OS.get_ticks_usec(), '')
	return yaw


func _input_left_right() -> int:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 68, OS.get_ticks_usec(), '')
	var left_right := 0
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 69, OS.get_ticks_usec(), '	var left_right := 0')
	if Input.is_action_pressed("left"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 70, OS.get_ticks_usec(), '	if Input.is_action_pressed("left"):')
		left_right += -1
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 71, OS.get_ticks_usec(), '		left_right += -1')
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 71, OS.get_ticks_usec(), '')
	if Input.is_action_pressed("right"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 72, OS.get_ticks_usec(), '	if Input.is_action_pressed("right"):')
		left_right += 1
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 73, OS.get_ticks_usec(), '		left_right += 1')
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 73, OS.get_ticks_usec(), '')
	return left_right


func _input_forward_back() -> int:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 77, OS.get_ticks_usec(), '')
	var forward_backward := 0
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 78, OS.get_ticks_usec(), '	var forward_backward := 0')
	if Input.is_action_pressed("forward"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 79, OS.get_ticks_usec(), '	if Input.is_action_pressed("forward"):')
		forward_backward += 1
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 80, OS.get_ticks_usec(), '		forward_backward += 1')
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 80, OS.get_ticks_usec(), '')
	if Input.is_action_pressed("back"):
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 81, OS.get_ticks_usec(), '	if Input.is_action_pressed("back"):')
		forward_backward += -1
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 82, OS.get_ticks_usec(), '		forward_backward += -1')
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 82, OS.get_ticks_usec(), '')
	return forward_backward


func update_rc_mode(val: bool) -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 86, OS.get_ticks_usec(), '')
	_rc_mode = val
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 87, OS.get_ticks_usec(), '	_rc_mode = val')


func _on_Send_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 90, OS.get_ticks_usec(), '')
	var cmd : String = ($DebugStuff/Box/Box/HBoxContainer/CmdTxt as LineEdit).text
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 91, OS.get_ticks_usec(), '	var cmd : String = ($DebugStuff/Box/Box/HBoxContainer/CmdTxt as LineEdit).text')
	if cmd.length() == 0:
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 92, OS.get_ticks_usec(), '	if cmd.length() == 0:')
		return
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 93, OS.get_ticks_usec(), '')
	_tello.send_cmd(cmd)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 94, OS.get_ticks_usec(), '	_tello.send_cmd(cmd)')


func _on_Tello_recived_control_code(val) -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 97, OS.get_ticks_usec(), '')
	$Header.update_status(_tello.last_command + ": " + val)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 98, OS.get_ticks_usec(), '	$Header.update_status(_tello.last_command + ": " + val)')


func _on_Tello_command_send(cmd) -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 101, OS.get_ticks_usec(), '')
	$Header.update_status(cmd + ": ?")
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 102, OS.get_ticks_usec(), '	$Header.update_status(cmd + ": ?")')


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 105, OS.get_ticks_usec(), '')
	if button_pressed:
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 106, OS.get_ticks_usec(), '	if button_pressed:')
		($DebugStuff as MarginContainer).rect_position.x = 5
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 107, OS.get_ticks_usec(), '		($DebugStuff as MarginContainer).rect_position.x = 5')
	else:
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 108, OS.get_ticks_usec(), '')
		($DebugStuff as MarginContainer).rect_position.x = -182
		NaiveGDScriptProfiler.note('Scripts/Main.gd', 109, OS.get_ticks_usec(), '		($DebugStuff as MarginContainer).rect_position.x = -182')
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 109, OS.get_ticks_usec(), '')


func _on_ClickController_speed_changed(val) -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 112, OS.get_ticks_usec(), '')
	_speed = val
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 113, OS.get_ticks_usec(), '	_speed = val')
	_tello.speed(val)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 114, OS.get_ticks_usec(), '	_tello.speed(val)')


func _on_ClickController_distance_changed(val) -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 117, OS.get_ticks_usec(), '')
	_distance = val
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 118, OS.get_ticks_usec(), '	_distance = val')


func _on_ClickController_angle_changed(val) -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 121, OS.get_ticks_usec(), '')
	_turn_angle = val
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 122, OS.get_ticks_usec(), '	_turn_angle = val')


func _on_TurnLeft_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 125, OS.get_ticks_usec(), '')
	_tello.ccw(_turn_angle)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 126, OS.get_ticks_usec(), '	_tello.ccw(_turn_angle)')


func _on_TurnRight_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 129, OS.get_ticks_usec(), '')
	_tello.cw(_turn_angle)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 130, OS.get_ticks_usec(), '	_tello.cw(_turn_angle)')


func _on_Up_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 133, OS.get_ticks_usec(), '')
	_tello.up(_distance)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 134, OS.get_ticks_usec(), '	_tello.up(_distance)')


func _on_Forward_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 137, OS.get_ticks_usec(), '')
	_tello.forward(_distance)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 138, OS.get_ticks_usec(), '	_tello.forward(_distance)')


func _on_Left_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 141, OS.get_ticks_usec(), '')
	_tello.left(_distance)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 142, OS.get_ticks_usec(), '	_tello.left(_distance)')


func _on_Right_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 145, OS.get_ticks_usec(), '')
	_tello.right(_distance)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 146, OS.get_ticks_usec(), '	_tello.right(_distance)')


func _on_Backward_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 150, OS.get_ticks_usec(), '')
	_tello.back(_distance)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 151, OS.get_ticks_usec(), '	_tello.back(_distance)')


func _on_Liftoff_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 153, OS.get_ticks_usec(), '')
	_tello.takeoff()
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 154, OS.get_ticks_usec(), '	_tello.takeoff()')
	_rc_mode_started = true
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 155, OS.get_ticks_usec(), '	_rc_mode_started = true')


func _on_Land_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 158, OS.get_ticks_usec(), '')
	_tello.land()
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 159, OS.get_ticks_usec(), '	_tello.land()')
	_rc_mode_started = false
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 160, OS.get_ticks_usec(), '	_rc_mode_started = false')


func _on_Down_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 164, OS.get_ticks_usec(), '')
	_tello.down(_distance)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 165, OS.get_ticks_usec(), '	_tello.down(_distance)')


func _on_ForwardLeft_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 167, OS.get_ticks_usec(), '')
	_tello.go(_distance, _distance, 0, _speed)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 168, OS.get_ticks_usec(), '	_tello.go(_distance, _distance, 0, _speed)')


func _on_ForwardRight_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 171, OS.get_ticks_usec(), '')
	_tello.go(_distance, -_distance, 0, _speed)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 172, OS.get_ticks_usec(), '	_tello.go(_distance, -_distance, 0, _speed)')


func _on_BackwardLeft_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 175, OS.get_ticks_usec(), '')
	_tello.go(-_distance, _distance, 0, _speed)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 176, OS.get_ticks_usec(), '	_tello.go(-_distance, _distance, 0, _speed)')


func _on_BackwardRight_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 179, OS.get_ticks_usec(), '')
	_tello.go(-_distance, -_distance, 0, _speed)
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 180, OS.get_ticks_usec(), '	_tello.go(-_distance, -_distance, 0, _speed)')


func _on_EmergencyOff_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 183, OS.get_ticks_usec(), '')
	_tello.emergency()
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 184, OS.get_ticks_usec(), '	_tello.emergency()')
	_rc_mode_started = false
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 185, OS.get_ticks_usec(), '	_rc_mode_started = false')


func _on_start_pressed() -> void:
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 188, OS.get_ticks_usec(), '')
	$Start/CenterContainer/Welcome.visible = false
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 189, OS.get_ticks_usec(), '	$Start/CenterContainer/Welcome.visible = false')
	$Start/CenterContainer/WaitAnimation.visible = true
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 190, OS.get_ticks_usec(), '	$Start/CenterContainer/WaitAnimation.visible = true')
	$Start/CenterContainer/WaitAnimation.play = true
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 191, OS.get_ticks_usec(), '	$Start/CenterContainer/WaitAnimation.play = true')
	_tello.start()
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 192, OS.get_ticks_usec(), '	_tello.start()')
	yield(_tello, "recived_control_code_ok")
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 193, OS.get_ticks_usec(), '	yield(_tello, "recived_control_code_ok")')
	$Start/CenterContainer/WaitAnimation.play = false
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 194, OS.get_ticks_usec(), '	$Start/CenterContainer/WaitAnimation.play = false')
	$Start.visible = false
	NaiveGDScriptProfiler.note('Scripts/Main.gd', 195, OS.get_ticks_usec(), '	$Start.visible = false')
