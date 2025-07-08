extends TextureRect

func _ready():
	# Fade-in startup screen.
	Animate.FadeIn(get_tree(), self)
	Animate.AnimProgress(get_tree(), %ProgressBar).connect(PreLoad)

func PreLoad() -> void:
	# Set up global scope for dialogs.
	Constants.GlobalRoot = get_tree().root

	Storage.OpenDatabase()

	get_window().size = Vector2i(1280, 720)
	get_window().borderless = false
	get_window().move_to_center()

	# Switch to the main screen.
	get_tree().change_scene_to_file("res://UI/Main.tscn")

func _exit_tree() -> void:
	print("[startup]: Tree is exiting...")
	Storage.Unlock()
