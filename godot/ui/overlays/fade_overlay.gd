class_name FadeOverlay
extends ColorRect

@export var fade_in_duration: float = 2.0
@export var fade_out_duration: float = 2.0
@export var auto_fade_in: bool = true
@export var minimum_opacity: float = 1.0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	modulate.a = minimum_opacity
	if auto_fade_in:
		fade_in()

func fade_in():
	return await Tweens.play(self, Tweens.modulate_alpha(0.0, fade_in_duration, Tweens.Ease.CUBIC_IN_OUT)).end

func fade_out():
	return await Tweens.play(self, Tweens.modulate_alpha(minimum_opacity, fade_out_duration, Tweens.Ease.CUBIC_IN_OUT)).end
