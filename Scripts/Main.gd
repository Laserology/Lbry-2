extends Control

func _ready() -> void:
	# Load projects into main view.
	LoadProjects()
	print("[main]: Loaded " + str(%ProjectList.item_count) + " projects from '" + Storage.SavePath + "'.")

func SortProjects(Query: String, SortBy: Constants.SearchBy) -> void:
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

func ListItemselected(Index: int) -> void:
	%ProjectDetails.Load(%ProjectList.get_item_text(Index))
	%ProjectList.deselect_all()
	ClearPressed()

func LoadProjects() -> void:
	%ProjectList.clear()
	for I in Storage.GetProjectNames():
		%ProjectList.add_item(I)

func SearchClicked() -> void:
	%SearchButton.hide()
	%ClearButton.show()
	SortProjects(%SearchBox.text, %SortMode.selected)

func ClearPressed() -> void:
	%SearchButton.show()
	%ClearButton.hide()
	%SearchBox.clear()
	LoadProjects()

func _exit_tree() -> void:
	print("[main]: Tree is exiting...")
	Storage.Unlock()
