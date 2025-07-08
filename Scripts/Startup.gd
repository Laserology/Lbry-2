extends TextureRect

func _ready():
	# Fade-in startup screen.
	Animate.FadeIn(get_tree(), self)
	Animate.AnimProgress(get_tree(), %ProgressBar).connect(PreLoad)

func PreLoad() -> void:
	# Warn about & Unlock the database.
	if Storage.IsLocked():
		Dialog.ShowMessagePopup("Alert", "This database is either already open in another window, or the database is incorrect. You can re-open the program again to fix it, but it is not recommended.", "Close").popup_centered()
		Storage.Close()
		get_tree().quit()

	# Load the database into memory.
	Storage.OpenDatabase()

	# Switch to the main screen.
	get_tree().change_scene_to_file("res://UI/Main.tscn")

func _exit_tree() -> void:
	Storage.Close()
