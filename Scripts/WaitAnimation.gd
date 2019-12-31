extends MarginContainer


export(int) var speed := 300
export(bool) var play := false setget set_play


onready var follower := $Path2D/follower as PathFollow2D


func _ready() -> void:
	NaiveGDScriptProfiler.note('Scripts/WaitAnimation.gd', 11, OS.get_ticks_usec(), '')
	set_physics_process(play)
	NaiveGDScriptProfiler.note('Scripts/WaitAnimation.gd', 12, OS.get_ticks_usec(), '	set_physics_process(play)')


func _physics_process(delta: float) -> void:
	NaiveGDScriptProfiler.note('Scripts/WaitAnimation.gd', 15, OS.get_ticks_usec(), '')
	follower.set_offset(follower.get_offset() + speed * delta)
	NaiveGDScriptProfiler.note('Scripts/WaitAnimation.gd', 16, OS.get_ticks_usec(), '	follower.set_offset(follower.get_offset() + speed * delta)')


func set_play(val: bool) -> void:
	NaiveGDScriptProfiler.note('Scripts/WaitAnimation.gd', 19, OS.get_ticks_usec(), '')
	set_physics_process(val)
	NaiveGDScriptProfiler.note('Scripts/WaitAnimation.gd', 20, OS.get_ticks_usec(), '	set_physics_process(val)')
	play = val
	NaiveGDScriptProfiler.note('Scripts/WaitAnimation.gd', 21, OS.get_ticks_usec(), '	play = val')
