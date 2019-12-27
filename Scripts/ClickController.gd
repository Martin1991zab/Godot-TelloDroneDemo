extends MarginContainer


signal speed_changed(val)
signal distance_changed(val)
signal angle_changed(val)


func _on_SpeedValTxt_value_changed(value: int) -> void:
    ($VBoxContainer/HBoxContainer/SpeedControl/VBoxContainer/SpeedSlider as VSlider).value = value
    emit_signal("speed_changed", value)


func _on_SpeedSlider_value_changed(value: int) -> void:
    ($VBoxContainer/HBoxContainer/SpeedControl/VBoxContainer/SpeedValTxt as SpinBox).value = value
    emit_signal("speed_changed", value)


func _on_DistanceSlider_value_changed(value: int) -> void:
    ($VBoxContainer/HBoxContainer/DistanceControl/VBoxContainer2/DistanceValTxt as SpinBox).value = value
    emit_signal("distance_changed", value)


func _on_DistanceValTxt_value_changed(value: int) -> void:
    ($VBoxContainer/HBoxContainer/DistanceControl/VBoxContainer2/DistanceSlider as VSlider).value = value
    emit_signal("distance_changed", value)


func _on_AngleValTxt_value_changed(value: int) -> void:
    ($VBoxContainer/HBoxContainer2/AngleSlider as Slider).value = value
    emit_signal("angle_changed", value)


func _on_AngleSlider_value_changed(value: int) -> void:
    ($VBoxContainer/HBoxContainer2/AngleValTxt as SpinBox).value = value
    emit_signal("angle_changed", value)
