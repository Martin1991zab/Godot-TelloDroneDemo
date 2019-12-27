extends MarginContainer


func update_bat(val: int) -> void:
    ($VBoxContainer/HBoxContainer/GridContainer/BatteryBar as TextureProgress).value = val
    ($VBoxContainer/HBoxContainer/GridContainer/BatteryVal as Label).text = String(val) + " %"


func update_yaw(val: int) -> void:
    $VBoxContainer/HBoxContainer/MarginContainer/AxesCircle.yaw = val


func update_roll(val: int) -> void:
    $VBoxContainer/HBoxContainer/MarginContainer/AxesCircle.roll = val


func update_pitch(val: int) -> void:
    $VBoxContainer/HBoxContainer/MarginContainer/AxesCircle.pitch = val


func update_temph(val: int) -> void:
    ($VBoxContainer/HBoxContainer/GridContainer/TemperaturHighBar as TextureProgress).value = val
    ($VBoxContainer/HBoxContainer/GridContainer/TemperaturHighVal as Label).text = String(val) + " °C"


func update_templ(val: int) -> void:
    ($VBoxContainer/HBoxContainer/GridContainer/TemperaturLowBar as TextureProgress).value = val
    ($VBoxContainer/HBoxContainer/GridContainer/TemperaturLowVal as Label).text = String(val) + " °C"


func update_hight(val: int) -> void:
    ($VBoxContainer/HBoxContainer2/HightSlider as HSlider).value = val
    ($VBoxContainer/HBoxContainer2/HightVal as Label).text = String(val) + " cm"


func update_time(val: int) -> void:
    $VBoxContainer/HBoxContainer/GridContainer/TimeBars.time = val
    var t := 0
    while val >= 60:
        t += 1
        val -= 60
    ($VBoxContainer/HBoxContainer/GridContainer/FlightTimeVal as Label).text = "{m}m {s}sec".format({"m": t, "s": val})


func update_status(val: String) -> void:
    ($VBoxContainer/HBoxContainer/GridContainer/StatusVal as Label).text = val


func update_hight_tof(val: int) -> void:
    ($VBoxContainer/HBoxContainer3/TofSlider as HSlider).value = val
    ($VBoxContainer/HBoxContainer3/TofVal as Label).text = String(val) + " cm"
