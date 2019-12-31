extends Node2D

export(int) var yaw: int = 0 setget set_yaw
export(int) var roll: int = 0 setget set_roll
export(int) var pitch: int = 0 setget set_pitch

func set_yaw(val: int) -> void:
    ($Yaw as Sprite).rotation_degrees = val

func set_roll(val: int) -> void:
    ($Roll as HSlider).value = val

func set_pitch(val: int) -> void:
    ($Pitch as VSlider).value = val
