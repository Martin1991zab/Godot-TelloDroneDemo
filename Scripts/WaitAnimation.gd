extends MarginContainer


export(int) var speed := 300
export(bool) var play := false setget set_play


onready var follower := $Path2D/follower as PathFollow2D


func _ready() -> void:
    set_physics_process(play)


func _physics_process(delta: float) -> void:
    follower.set_offset(follower.get_offset() + speed * delta)


func set_play(val: bool) -> void:
    set_physics_process(val)
    play = val
