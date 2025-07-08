extends TextureRect

var StartupTask: int = 0

func _ready():
	# Set window properties.
	get_window().size = Vector2i(600, 400)
	get_window().move_to_center()

	# Fade-in startup screen.
	Animate.FadeIn(get_tree(), self)
	Animate.AnimProgress(get_tree(), %ProgressBar)

	# Warn about & Unlock the database.
	if Storage.IsLocked():
		Dialog.ShowMessagePopup("Alert", "This database is either already open in another window, or the database is incorrect. You can re-open the program again to fix it, but it is not recommended.", "Close").popup_centered()
		Storage.Close()
		get_tree().quit()

func _process(_delta):
	# Load database if not started already.
	if StartupTask == 0:
		StartupTask = WorkerThreadPool.add_task(Storage.OpenDatabase)
	if WorkerThreadPool.is_task_completed(StartupTask):
		SwitchToProjects()

func SwitchToProjects():
	# Ensure at least one second passes until splash screen fades out.
	get_tree().create_timer(1).timeout.connect(get_tree().change_scene_to_file.bind("res://UI/Main.tscn"))

func _exit_tree() -> void:
	Storage.Close()
