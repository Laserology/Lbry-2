extends Control

func _ready():
	# Load projects into main view.
	LoadProjects()
	get_window().size = Vector2i(1280, 720)
	get_window().borderless = false
	get_window().move_to_center()

func SortProjects(Query: String, SortBy: Constants.SearchBy):
	%ProjectList.clear()
	Query = Query.to_lower()

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

func LoadProjects() -> void:
	%ProjectList.clear()
	for I in Storage.GetProjectNames():
		%ProjectList.add_item(I)

func ListItemselected(Index: int) -> void:
	%ProjectList.deselect_all()
	%ProjectDetails.Load(%ProjectList.get_item_text(Index))

func SearchClicked() -> void:
	%SearchButton.hide()
	%ClearButton.show()
	SortProjects(%SearchBox.text, %SortMode.selected)

func ClearPressed() -> void:
	%SearchButton.show()
	%ClearButton.hide()
	LoadProjects()
