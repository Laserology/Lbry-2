extends ColorRect

# To-Do: Mark "was modified" if any fields changed (use signals).

# Used to detect name changes.
var OriginalSelection: String = ""
var ConfirmDelete: bool = false
var IsNewProject: bool = false

# Find the number of days since a particular library card was used.
func DaysSinceUsed(CardNumber: String) -> int:
	var Oldest: int = 0
	for N in Storage.GetProjectNames():
		if Storage.DB.get_value(N, Constants.CARD_NUMBER, "") == CardNumber:
			var CardUse: int = Storage.DB.get_value(N, Constants.LAST_UPDATED, 0)
			Oldest = max(CardUse, Oldest)

	# If no last-date was found, set it to today.
	if Oldest == 0:
		Oldest = Time.get_unix_time_from_system()

	# The number '86400' is the number of seconds in a day.
	# We divide by it becsue unix time stamp is in seconds since epoch.
	return (Time.get_unix_time_from_system() - Oldest) / 86400.0

# Warn if a library card was used more than once in a month.
func EditingToggled(Toggled: bool) -> void:
	if !Toggled:
		var DaysAgo: int = DaysSinceUsed(%CardNumber.text)
		print("[details] Card last use detected: " + str(DaysAgo))
		if DaysAgo != 0 && DaysAgo <= 28 && !%CardNumber.text.is_empty():
			Dialog.ShowMessagePopup("Alert", "This library card was used " + str(DaysAgo) + " day(s) ago!")

# Runs when the "Save & Close" button is pressed.
func ProjectDetailsClose() -> void:
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

		if IsNewProject:
			Storage.DB.set_value(%ProjectName.text, Constants.LAST_UPDATED, Time.get_unix_time_from_system())

		# Save new details & Reload main menu.
		Storage.Reload()

	# Load projects into main view.
	%ProjectList.clear()
	for I in Storage.GetProjectNames():
		%ProjectList.add_item(I)

	if %CardNumber.text.is_empty():
		Dialog.ShowMessagePopup("Alert", "You didn't enter any library card number!")

	# Slide back to the main menu.
	Close()

# Load a project into the project menu.
func Load(Project: String) -> void:
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

# Ask user to confirm deletion.
func DeletePressed() -> void:
	if ConfirmDelete:
		print("[main]: Removing '" + %ProjectName.text + "'...")
		Storage.DB.erase_section(%ProjectName.text)
		Storage.DB.save(Storage.SavePath)

		# Load projects into main view.
		%ProjectList.clear()
		for I in Storage.GetProjectNames():
			%ProjectList.add_item(I)
		Close()
	else:
		%Delete.text = "Press again to confirm"
		ConfirmDelete = true

# Runs when the "New Project" button is pressed.
func NewProject():
	IsNewProject = true;
	Open()
	Clear()
	%ProjectName.text = "New Project - " + Time.get_datetime_string_from_system()

# Opens the page link where the models are saved.
func OpenProjectPage() -> void:
	match %Platform.selected:
		0: OS.shell_open("https://www.thingiverse.com/thing:%s/files" % str(%ProjectID.text))
		1: OS.shell_open("https://www.printables.com/model/%s/files" % str(%ProjectID.text))
		2: OS.shell_open(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + %ProjectID.text)

# Open project menu animation.
func Open() -> void:
	# Slide to the project menu.
	Animate.SlideTo(get_tree(), %ProjectDetails, Vector2(0, 0), 0.5)

# Close project menu animation.
func Close() -> void:
	# Slide back to the main menu.
	Animate.SlideTo(get_tree(), %ProjectDetails, Vector2(1280, 0), 0.5)
	%Delete.text = "Delete"
	ConfirmDelete = false
	IsNewProject = false

# Clears all fields in the project view.
func Clear() -> void:
	%ProjectName.clear()
	%Cardholder.clear()
	%ProjectID.clear()
	%Platform.select(0)
	%CardNumber.clear()
	%ProjectColor.clear()
	%ApprovedBy.clear()
	%Notes.clear()
