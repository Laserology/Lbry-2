extends ColorRect

# Used to detect name changes.
var OriginalSelection: String = ""
var ConfirmDelete: bool = false

# Load a project into the project menu.
func Load(Project: String):
	OriginalSelection = Project
	%ProjectName.text = Project
	%Cardholder.text = Storage.DB.get_value(Project, Constants.CARD_HOLDER, "")
	%ProjectID.text = Storage.DB.get_value(Project, Constants.PROJECT_ID, "")
	%Platform.select(Storage.DB.get_value(Project, Constants.PROJECT_SOURCE, 0))
	%CardNumber.text = Storage.DB.get_value(Project, Constants.CARD_NUMBER, "")
	%ProjectColor.text = Storage.DB.get_value(Project, Constants.PROJECT_COLOR, "")
	%ApprovedBy.text = Storage.DB.get_value(Project, Constants.SIGNATURE, "")
	%Notes.text = Storage.DB.get_value(Project, Constants.PROJECT_NOTES, "")
	Animate.SlideTo(get_tree(), %ProjectDetails, Vector2(0, 0), 0.5)

# Clears all fields in the project view.
func Clear():
	%ProjectName.clear()
	%Cardholder.clear()
	%ProjectID.clear()
	%Platform.select(0)
	%CardNumber.clear()
	%ProjectColor.clear()
	%ApprovedBy.clear()
	%Notes.clear()

# Runs when the "Save & Close" button is pressed.
func ProjectDetailsClose():
	# Save new values to storage.
	if !%ProjectName.text.is_empty():
		# Delete old entry if it was renamed.
		#if OriginalSelection != %ProjectName.text && !OriginalSelection.is_empty():
		#	Storage.DB.erase_section(OriginalSelection)

		Storage.DB.set_value(%ProjectName.text, Constants.CARD_HOLDER, %Cardholder.text)
		Storage.DB.set_value(%ProjectName.text, Constants.PROJECT_ID, %ProjectID.text)
		Storage.DB.set_value(%ProjectName.text, Constants.PROJECT_SOURCE, %Platform.selected)
		Storage.DB.set_value(%ProjectName.text, Constants.CARD_NUMBER, %CardNumber.text)
		Storage.DB.set_value(%ProjectName.text, Constants.PROJECT_COLOR, %ProjectColor.text)
		Storage.DB.set_value(%ProjectName.text, Constants.SIGNATURE, %ApprovedBy.text)
		Storage.DB.set_value(%ProjectName.text, Constants.PROJECT_NOTES, %Notes.text)

		# Save new details & Reload main menu.
		Storage.Reload()

	# Load projects into main view.
	%ProjectList.clear()
	for I in Storage.GetProjectNames():
		%ProjectList.add_item(I)

	# Slide back to the main menu.
	Animate.SlideTo(get_tree(), %ProjectDetails, Vector2(1280, 0), 0.5)

# Ask user to confirm deletion.
func DeletePressed() -> void:
	if ConfirmDelete:
		Storage.DB.erase_section(%ProjectName.text)
		Storage.DB.save(Storage.SavePath)

		# Load projects into main view.
		%ProjectList.clear()
		for I in Storage.GetProjectNames():
			%ProjectList.add_item(I)
		%Delete.text = "Delete"

		# Slide back to the main menu.
		Animate.SlideTo(get_tree(), %ProjectDetails, Vector2(1280, 0), 0.5)

		ConfirmDelete = false
	else:
		%Delete.text = "Press again to confirm"
		ConfirmDelete = true

# Runs when the "New Project" button is pressed.
func NewProject():
	Animate.SlideTo(get_tree(), %ProjectDetails, Vector2(0, 0), 0.5)
	Clear()
	%ProjectName.text = "New Project - " + Time.get_datetime_string_from_system()

# Opens the page link where the models are saved.
func OpenProjectPage() -> void:
	match %Platform.selected:
		0: OS.shell_open("https://www.thingiverse.com/thing:%s/files" % str(%ProjectID.text))
		1: OS.shell_open("https://www.printables.com/model/%s/files" % str(%ProjectID.text))
		2: OS.shell_open(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + %ProjectID.text)
