extends Node

var file := File.new()

func _ready() -> void:
	var path := "user://profiler.log"
	file.open(path, File.WRITE)
	file.seek_end()

func _exit_tree() -> void:
	file.close()

func note(filename: String, linenr: int, tick_usec: int, line: String) -> void:
	# NaiveGDScriptProfiler.note('Scripts/AxesCircle.gd', 7, OS.get_ticks_usec(), '')
	var tmp := [filename, String(linenr), String(tick_usec), line];
	file.store_csv_line(tmp, ";")
