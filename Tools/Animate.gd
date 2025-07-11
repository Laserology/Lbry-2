class_name Animate
extends Node

static func FadeIn(Obj: Object, Wait: float = 0.5) -> Signal:
	var Anim = Constants.GlobalRoot.get_tree().create_tween()
	Obj.modulate.a = 0
	Anim.tween_property(Obj, "modulate:a", 1, Wait)
	Anim.play()
	Anim.connect("finished", Anim.kill)
	return Anim.finished

static func FadeOut(Obj: Object, Wait: float = 0.5) -> Signal:
	var Anim = Constants.GlobalRoot.get_tree().create_tween()
	Obj.modulate.a = 1
	Anim.tween_property(Obj, "modulate:a", 0, Wait)
	Anim.play()
	Anim.connect("finished", Anim.kill)
	return Anim.finished

static func SlideTo(Obj: Object, To: Vector2, Wait: float = 1.0) -> Signal:
	var Anim = Constants.GlobalRoot.get_tree().create_tween()
	Anim.tween_property(Obj, "position", To, Wait).set_trans(Tween.TRANS_EXPO)
	Anim.play()
	Anim.connect("finished", Anim.kill)
	return Anim.finished

static func AnimProgress(Obj: Object) -> Signal:
	var Anim = Constants.GlobalRoot.get_tree().create_tween()
	Anim.tween_property(Obj, "value", 100, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	Anim.play()
	Anim.connect("finished", Anim.kill)
	return Anim.finished
