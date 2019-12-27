extends Node


onready var _tello := $Tello as Tello


var _speed := 100
var _distance := 20
var _turn_angle := 1
var _rc_mode := false setget update_rc_mode
var _rc_mode_started := false


func _ready() -> void:
    $Start.visible = true


func _process(_delta: float) -> void:
    if !_rc_mode:
        return
    if Input.is_action_just_pressed("emergency"):
        _tello.emergency()
        _rc_mode = false
        _rc_mode_started = false
        $DebugStuff/Box/Box/RC.pressed = false
        return
    if Input.is_action_just_pressed("takeoff"):
        _tello.takeoff()
        _rc_mode_started = true
        return
    if Input.is_action_just_pressed("land"):
        _tello.land()
        _rc_mode = false
        _rc_mode_started = false
        $DebugStuff/Box/Box/RC.pressed = false
        return
    _handle_rc_control()


func _handle_rc_control() -> void:
    if !_rc_mode_started:
        return
    var forward_backward := _input_forward_back()
    var left_right := _input_left_right()
    var yaw := _input_turn_left_right()
    var up_down := _input_up_down()
    _tello.rc(left_right * _speed, forward_backward * _speed, up_down * _speed, yaw * _speed)


func _input_up_down() -> int:
    var up_down := 0
    if Input.is_action_pressed("up"):
        up_down += 1
    if Input.is_action_pressed("down"):
        up_down += -1
    return up_down


func _input_turn_left_right() -> int:
    var yaw := 0
    if Input.is_action_pressed("turn_left"):
        yaw += -1
    if Input.is_action_pressed("turn_right"):
        yaw += 1
    return yaw


func _input_left_right() -> int:
    var left_right := 0
    if Input.is_action_pressed("left"):
        left_right += -1
    if Input.is_action_pressed("right"):
        left_right += 1
    return left_right


func _input_forward_back() -> int:
    var forward_backward := 0
    if Input.is_action_pressed("forward"):
        forward_backward += 1
    if Input.is_action_pressed("back"):
        forward_backward += -1
    return forward_backward


func update_rc_mode(val: bool) -> void:
    _rc_mode = val


func _on_Send_pressed() -> void:
    var cmd : String = ($DebugStuff/Box/Box/HBoxContainer/CmdTxt as LineEdit).text
    if cmd.length() == 0:
        return
    _tello.send_cmd(cmd)


func _on_Tello_recived_control_code(val) -> void:
    $Header.update_status(_tello.last_command + ": " + val)


func _on_Tello_command_send(cmd) -> void:
    $Header.update_status(cmd + ": ?")


func _on_CheckBox_toggled(button_pressed: bool) -> void:
    if button_pressed:
        ($DebugStuff as MarginContainer).rect_position.x = 5
    else:
        ($DebugStuff as MarginContainer).rect_position.x = -182


func _on_ClickController_speed_changed(val) -> void:
    _speed = val
    _tello.speed(val)


func _on_ClickController_distance_changed(val) -> void:
    _distance = val


func _on_ClickController_angle_changed(val) -> void:
    _turn_angle = val


func _on_TurnLeft_pressed() -> void:
    _tello.ccw(_turn_angle)


func _on_TurnRight_pressed() -> void:
    _tello.cw(_turn_angle)


func _on_Up_pressed() -> void:
    _tello.up(_distance)


func _on_Forward_pressed() -> void:
    _tello.forward(_distance)


func _on_Left_pressed() -> void:
    _tello.left(_distance)


func _on_Right_pressed() -> void:
    _tello.right(_distance)


func _on_Backward_pressed() -> void:
    _tello.back(_distance)


func _on_Liftoff_pressed() -> void:
    _tello.takeoff()
    _rc_mode_started = true


func _on_Land_pressed() -> void:
    _tello.land()
    _rc_mode_started = false


func _on_Down_pressed() -> void:
    _tello.down(_distance)


func _on_ForwardLeft_pressed() -> void:
    _tello.go(_distance, _distance, 0, _speed)


func _on_ForwardRight_pressed() -> void:
    _tello.go(_distance, -_distance, 0, _speed)


func _on_BackwardLeft_pressed() -> void:
    _tello.go(-_distance, _distance, 0, _speed)


func _on_BackwardRight_pressed() -> void:
    _tello.go(-_distance, -_distance, 0, _speed)


func _on_EmergencyOff_pressed() -> void:
    _tello.emergency()
    _rc_mode_started = false


func _on_start_pressed() -> void:
    $Start/CenterContainer/Welcome.visible = false
    $Start/CenterContainer/WaitAnimation.visible = true
    $Start/CenterContainer/WaitAnimation.play = true
    _tello.start()
    yield(_tello, "recived_control_code_ok")
    $Start/CenterContainer/WaitAnimation.play = false
    $Start.visible = false
