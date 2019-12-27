extends VBoxContainer

export(int) var time : int = 0 setget set_time

func set_time(val: int) -> void:
    ($Minuets as TextureProgress).value = val
    while val >= 60:
        val -= 60
    ($Seconds as TextureProgress).value = val
