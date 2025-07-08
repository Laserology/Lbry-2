class_name Storage
extends Node

static var SavePath: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/Library.cfg"
static var DB: ConfigFile = ConfigFile.new()

static func OpenDatabase() -> void:
	var E = DB.load(SavePath)
	if E != 0 && E != 7:
		Dialog.ShowMessagePopup("Alert", "Something went wrong while loading the project database. Error code " + E).popup_centered()
		return

	# Lock the software to prevent data issues.
	DB.set_value(Constants.RESERVED_SECTION, Constants.LOCK_CONST, "LOCKED")
	DB.save(SavePath)

static func GetProjectNames() -> PackedStringArray:
	var Output: PackedStringArray = []
	var Sections: PackedStringArray = DB.get_sections()
	Sections.reverse()
	for N in Sections:
		if N != Constants.RESERVED_SECTION:
			Output.append(N)

	return Output

static func IsLocked() -> bool:
	return DB.get_value(Constants.RESERVED_SECTION, Constants.LOCK_CONST, "") == "LOCKED"

static func Reload() -> void:
	DB.save(Storage.SavePath)
	DB.load(Storage.SavePath)

static func Close() -> void:
	# Unlock the software & Save.
	DB.erase_section_key(Constants.RESERVED_SECTION, Constants.LOCK_CONST)
	DB.save(SavePath)
