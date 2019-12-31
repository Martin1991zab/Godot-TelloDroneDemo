extends Node

func note(filename: String, linenr: int, tick_usec: int, line: String) -> void:
	# NaiveGDScriptProfiler.note('Scripts/AxesCircle.gd', 7, OS.get_ticks_usec(), '')
	var tmp = filename + ";" + String(linenr) + ";" + String(tick_usec) + ";" + line
	pass
