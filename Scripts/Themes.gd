extends OptionButton

static var ColorTerracotta: Color = Color.from_string("#16030b", Color.BLACK)
static var ColorNormal: Color = Color.from_string("#1e1e2b", Color.BLACK)
static var ColorLight: Color = Color.WHITE

# Runs when a new theme is selected in the dropdown.
func ThemeSelected(Index) -> void:
	print("[main] Setting new theme...")
	var ReplacementA: Theme
	var ReplacementD: Theme
	var Replacement: Theme

	match Index:
		0:
			%Main.color = ColorNormal
			%ProjectDetails.color = ColorNormal
			Replacement = preload("res://Assets/Common.tres")
			ReplacementA = preload("res://Assets/ButtonAccept.tres")
			ReplacementD = preload("res://Assets/ButtonReject.tres")
		1:
			%Main.color = ColorLight
			%ProjectDetails.coThemeslor = ColorLight
		2:
			%Main.color = ColorTerracotta
			%ProjectDetails.color = ColorTerracotta
			Replacement = preload("res://Assets/Common Terracotta.tres")
			ReplacementA = preload("res://Assets/ButtonAccept Terracotta.tres")
			ReplacementD = preload("res://Assets/ButtonReject Terracotta.tres")
		_: return

	# Write theme settings to config file.
	Storage.DB.set_value(Constants.RESERVED_SECTION, Constants.THEME_SETTING, Index)
	Storage.Reload()

	ApplyToAll(%Main.get_parent(), Replacement)
	%NewProject.theme = ReplacementA
	%Save.theme = ReplacementA
	%Delete.theme = ReplacementD

# Applies a selected theme to all controls in the scene. Internal use only.
static func ApplyToAll(Target: Node, Value: Theme) -> void:
	for N in Target.get_children():
		if N.get_child_count() > 0:
			ApplyToAll(N, Value)
		else:
			if N is Control:
				N.theme = Value
