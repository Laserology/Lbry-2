extends ColorRect

# Runs when the scene is opened.
func _ready() -> void:
	var ThemeIndex: int = Storage.DB.get_value(Constants.RESERVED_SECTION, Constants.THEME_SETTING, 0)
	%ThemeSelector.ThemeSelected(ThemeIndex)
	%ThemeSelector.select(ThemeIndex)

	# Load projects into main view.
	LoadProjects()
	print("[main]: Loaded " + str(%ProjectList.item_count) + " projects from '" + Storage.SavePath + "'.")

# Sorts the main menu projects list by a query.
func SortProjects(Query: String, SortBy: Constants.SearchBy) -> void:
	LoadProjects()
	%ProjectList.clear()
	Query = Query.to_lower()

	print("[main] Sorting project list by " + str(SortBy))

	match SortBy:
		Constants.SearchBy.Title:
			for N in Storage.DB.get_sections():
				if N == Constants.RESERVED_SECTION:
					pass
				if N.to_lower().contains(Query):
					%ProjectList.add_item(N)
		Constants.SearchBy.Description:
			for N in Storage.DB.get_sections():
				if N == Constants.RESERVED_SECTION:
					pass
				if Storage.DB.get_value(N, Constants.PROJECT_NOTES, "").to_lower().contains(Query):
					%ProjectList.add_item(N)
		Constants.SearchBy.LibraryCard:
			for N in Storage.DB.get_sections():
				if N == Constants.RESERVED_SECTION:
					pass
				if Storage.DB.get_value(N, Constants.CARD_NUMBER, "").contains(Query):
					%ProjectList.add_item(N)

# Runs when the user selects an item from the main menu list.
func ListItemselected(Index: int) -> void:
	%SlideMenu.Load(%ProjectList.get_item_text(Index))
	%ProjectList.deselect_all()
	ClearPressed()

# Loads the projects into the main menu list.
func LoadProjects() -> void:
	%ProjectList.clear()
	for I in Storage.GetProjectNames():
		%ProjectList.add_item(I)

# Runs when the search button is pressed.
func SearchClicked() -> void:
	LoadProjects()
	%SearchButton.hide()
	%ClearButton.show()
	SortProjects(%SearchBox.text, %SortMode.selected)

# Runs when the "clear" button on the search bar is pressed.
func ClearPressed() -> void:
	%SearchButton.show()
	%ClearButton.hide()
	%SearchBox.clear()
	LoadProjects()

# Runs when the "New Project" button is pressed.
func NewProject() -> void:
	%SlideMenu.IsNewProject = true;
	%SlideMenu.Clear()
	%SlideMenu.Open()
	%SlideMenu.get_node("%ProjectName").text = "New Project - " + Time.get_datetime_string_from_system()

# Save & Quit when exiting.
func _exit_tree() -> void:
	%SlideMenu	.Close()
	print("[main]: Tree is exiting...")
	Storage.Unlock()
