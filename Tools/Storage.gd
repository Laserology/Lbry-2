class_name Storage
extends Node

static var SavePath: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/Library.cfg"
static var DB: ConfigFile = ConfigFile.new()

# Load full database into memory.
static func OpenDatabase() -> void:
	var E = DB.load(SavePath)
	if E != 0 && E != 7:
		Dialog.ShowMessagePopup("Alert", "Something went wrong while loading the project database.\nError code " + str(E))
		return

	# Warn about & Unlock the database.
	if IsLocked():
		Dialog.ShowMessagePopup("Alert", "This database is either already open in another window, or the database is incorrect.\nYou can continue to use the program, but it is not recommended.", "Dismiss")
	else:
		Lock()

# Get a list of all project names, ommiting all sections used for configs.
static func GetProjectNames() -> PackedStringArray:
	var Output: PackedStringArray = []
	var Sections: PackedStringArray = DB.get_sections()
	Sections.reverse()
	for N in Sections:
		if N != Constants.RESERVED_SECTION:
			Output.append(N)

	return Output

# Check if the database is already in use.
static func IsLocked() -> bool:
	return DB.get_value(Constants.RESERVED_SECTION, Constants.LOCK_CONST, "") == "LOCKED"

# Reload the database in-place.
static func Reload() -> void:
	DB.save(Storage.SavePath)
	DB.load(Storage.SavePath)

# Unlock & Save the database - aka close.
static func Unlock() -> void:
	DB.erase_section_key(Constants.RESERVED_SECTION, Constants.LOCK_CONST)
	Reload()

# Lock the database, which will trigger a warning if opened twice.
static func Lock() -> void:
	# Lock the software to prevent data issues.
	DB.set_value(Constants.RESERVED_SECTION, Constants.LOCK_CONST, "LOCKED")
	Reload()
