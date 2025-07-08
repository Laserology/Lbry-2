class_name Animate
extends Node

static func FadeIn(Base: SceneTree, Obj: Object, Wait: float = 0.5) -> void:
	var Anim = Base.create_tween()
	Obj.modulate.a = 0
	Anim.tween_property(Obj, "modulate:a", 1, Wait)
	Anim.play()
	Anim.connect("finished", Anim.kill)

static func FadeOut(Base: SceneTree, Obj: Object, Wait: float = 0.5) -> void:
	var Anim = Base.create_tween()
	Obj.modulate.a = 1
	Anim.tween_property(Obj, "modulate:a", 0, Wait)
	Anim.play()
	Anim.connect("finished", Anim.kill)

static func SlideTo(Base: SceneTree, Obj: Object, To: Vector2, Wait: float = 1.0):
	var Anim = Base.create_tween()
	Anim.tween_property(Obj, "position", To, Wait).set_trans(Tween.TRANS_EXPO)
	Anim.play()
	Anim.connect("finished", Anim.kill)

static func AnimProgress(Base: SceneTree, Obj: Object):
	var Anim = Base.create_tween()
	Anim.tween_property(Obj, "value", 100, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	Anim.play()
	Anim.connect("finished", Anim.kill)
