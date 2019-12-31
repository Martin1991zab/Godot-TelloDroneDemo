extends Node2D

export(int) var yaw: int = 0 setget set_yaw
export(int) var roll: int = 0 setget set_roll
export(int) var pitch: int = 0 setget set_pitch

func set_yaw(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/AxesCircle.gd', 7, OS.get_ticks_usec(), '')
	($Yaw as Sprite).rotation_degrees = val
	NaiveGDScriptProfiler.note('Scripts/AxesCircle.gd', 8, OS.get_ticks_usec(), '	($Yaw as Sprite).rotation_degrees = val')

func set_roll(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/AxesCircle.gd', 10, OS.get_ticks_usec(), '')
	($Roll as HSlider).value = val
	NaiveGDScriptProfiler.note('Scripts/AxesCircle.gd', 11, OS.get_ticks_usec(), '	($Roll as HSlider).value = val')

func set_pitch(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/AxesCircle.gd', 13, OS.get_ticks_usec(), '')
	($Pitch as VSlider).value = val
	NaiveGDScriptProfiler.note('Scripts/AxesCircle.gd', 14, OS.get_ticks_usec(), '	($Pitch as VSlider).value = val')
