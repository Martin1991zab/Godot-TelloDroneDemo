extends MarginContainer


func update_bat(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 4, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/GridContainer/BatteryBar as TextureProgress).value = val
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 5, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/GridContainer/BatteryVal as Label).text = String(val) + " %"
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 6, OS.get_ticks_usec(), '')


func update_yaw(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 9, OS.get_ticks_usec(), '')
	$VBoxContainer/HBoxContainer/MarginContainer/AxesCircle.yaw = val
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 10, OS.get_ticks_usec(), '')


func update_roll(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 13, OS.get_ticks_usec(), '')
	$VBoxContainer/HBoxContainer/MarginContainer/AxesCircle.roll = val
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 14, OS.get_ticks_usec(), '')


func update_pitch(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 17, OS.get_ticks_usec(), '')
	$VBoxContainer/HBoxContainer/MarginContainer/AxesCircle.pitch = val
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 18, OS.get_ticks_usec(), '')


func update_temph(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 21, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/GridContainer/TemperaturHighBar as TextureProgress).value = val
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 22, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/GridContainer/TemperaturHighVal as Label).text = String(val) + " °C"
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 23, OS.get_ticks_usec(), '')


func update_templ(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 26, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/GridContainer/TemperaturLowBar as TextureProgress).value = val
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 27, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/GridContainer/TemperaturLowVal as Label).text = String(val) + " °C"
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 28, OS.get_ticks_usec(), '')


func update_hight(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 31, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer2/HightSlider as HSlider).value = val
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 32, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer2/HightVal as Label).text = String(val) + " cm"
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 33, OS.get_ticks_usec(), '')


func update_time(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 36, OS.get_ticks_usec(), '')
	$VBoxContainer/HBoxContainer/GridContainer/TimeBars.time = val
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 37, OS.get_ticks_usec(), '')
	var t := 0
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 38, OS.get_ticks_usec(), '')
	while val >= 60:
		NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 39, OS.get_ticks_usec(), '')
		t += 1
		NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 40, OS.get_ticks_usec(), '')
		val -= 60
		NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 41, OS.get_ticks_usec(), '')
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 41, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/GridContainer/FlightTimeVal as Label).text = "{m}m {s}sec".format({"m": t, "s": val})
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 42, OS.get_ticks_usec(), '')


func update_status(val: String) -> void:
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 45, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer/GridContainer/StatusVal as Label).text = val
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 46, OS.get_ticks_usec(), '')


func update_hight_tof(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 49, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer3/TofSlider as HSlider).value = val
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 50, OS.get_ticks_usec(), '')
	($VBoxContainer/HBoxContainer3/TofVal as Label).text = String(val) + " cm"
	NaiveGDScriptProfiler.note('Scripts/InformationHeader.gd', 51, OS.get_ticks_usec(), '')
