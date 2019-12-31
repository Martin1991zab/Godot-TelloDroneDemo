extends MarginContainer


signal speed_changed(val)
signal distance_changed(val)
signal angle_changed(val)


func _on_SpeedValTxt_value_changed(value: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 10, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/SpeedControl/VBoxContainer/SpeedSlider as VSlider).value = value
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 10, OS.get_ticks_usec(), '	($VBoxContainer/HBoxContainer/SpeedControl/VBoxContainer/SpeedSlider as VSlider).value = value')
	emit_signal("speed_changed", value)
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 11, OS.get_ticks_usec(), '	emit_signal("speed_changed", value)')


func _on_SpeedSlider_value_changed(value: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 14, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/SpeedControl/VBoxContainer/SpeedValTxt as SpinBox).value = value
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 15, OS.get_ticks_usec(), '	($VBoxContainer/HBoxContainer/SpeedControl/VBoxContainer/SpeedValTxt as SpinBox).value = value')
	emit_signal("speed_changed", value)
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 16, OS.get_ticks_usec(), '	emit_signal("speed_changed", value)')


func _on_DistanceSlider_value_changed(value: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 19, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/DistanceControl/VBoxContainer2/DistanceValTxt as SpinBox).value = value
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 20, OS.get_ticks_usec(), '	($VBoxContainer/HBoxContainer/DistanceControl/VBoxContainer2/DistanceValTxt as SpinBox).value = value')
	emit_signal("distance_changed", value)
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 21, OS.get_ticks_usec(), '	emit_signal("distance_changed", value)')


func _on_DistanceValTxt_value_changed(value: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 24, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/DistanceControl/VBoxContainer2/DistanceSlider as VSlider).value = value
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 25, OS.get_ticks_usec(), '	($VBoxContainer/HBoxContainer/DistanceControl/VBoxContainer2/DistanceSlider as VSlider).value = value')
	emit_signal("distance_changed", value)
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 26, OS.get_ticks_usec(), '	emit_signal("distance_changed", value)')


func _on_AngleValTxt_value_changed(value: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 29, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer2/AngleSlider as Slider).value = value
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 30, OS.get_ticks_usec(), '	($VBoxContainer/HBoxContainer2/AngleSlider as Slider).value = value')
	emit_signal("angle_changed", value)
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 31, OS.get_ticks_usec(), '	emit_signal("angle_changed", value)')


func _on_AngleSlider_value_changed(value: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 34, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer2/AngleValTxt as SpinBox).value = value
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 35, OS.get_ticks_usec(), '	($VBoxContainer/HBoxContainer2/AngleValTxt as SpinBox).value = value')
	emit_signal("angle_changed", value)
	NaiveGDScriptProfiler.note('Scripts/ClickController.gd', 36, OS.get_ticks_usec(), '	emit_signal("angle_changed", value)')
