extends Node

var camera : Camera3D:
	get:
		return %Camera3D

var follow : Node3D:
	get:
		return %CameraFollow.target
	set(value):
		%CameraFollow.target = value

#var look : Node3D:
#	get:
#		return %CameraLook.target
#	set(value):
#		%CameraLook.target = value

var shake : float:
	get:
		return %CameraShake.trauma
	set(value):
		%CameraShake.trauma = value

func warp():
	%CameraFollow.warp()

func soft():
	%CameraPositionMover.motion_smooth_time = 2.0
	%CameraLookMover.motion_smooth_time = 2.0

func stiff():
	%CameraPositionMover.motion_smooth_time = 0.5
	%CameraLookMover.motion_smooth_time = 0.3
