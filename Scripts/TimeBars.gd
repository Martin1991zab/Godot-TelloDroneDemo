extends VBoxContainer

export(int) var time : int = 0 setget set_time

func set_time(val: int) -> void:
	NaiveGDScriptProfiler.note('Scripts/TimeBars.gd', 5, OS.get_ticks_usec(), '')
	($Minuets as TextureProgress).value = val
	NaiveGDScriptProfiler.note('Scripts/TimeBars.gd', 6, OS.get_ticks_usec(), '	($Minuets as TextureProgress).value = val')
	while val >= 60:
		NaiveGDScriptProfiler.note('Scripts/TimeBars.gd', 7, OS.get_ticks_usec(), '	while val >= 60:')
		val -= 60
		NaiveGDScriptProfiler.note('Scripts/TimeBars.gd', 8, OS.get_ticks_usec(), '	val -= 60')
	NaiveGDScriptProfiler.note('Scripts/TimeBars.gd', 8, OS.get_ticks_usec(), '')
	($Seconds as TextureProgress).value = val
	NaiveGDScriptProfiler.note('Scripts/TimeBars.gd', 9, OS.get_ticks_usec(), '	($Seconds as TextureProgress).value = val')
