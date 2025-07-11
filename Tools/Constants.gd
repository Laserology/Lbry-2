class_name Constants
extends Node

static var GlobalRoot: Node

# Special reserved section not to use.
const RESERVED_SECTION = "LOADER_CONFIG_SECTION_DO_NOT_USE"
const LOCK_CONST = "SOFTWARE_SECONDARY_OPEN_LOCK"
const THEME_SETTING = "SOFTWARE_THEME_SETTING"

const REASON_WEAPON = "Weapons are not allowed to be printed!"

const BLACKLISTED_IDS = {
	"7051455": REASON_WEAPON,
}

# Common names for every listing.
const CARD_HOLDER = "CardHolder"
const CARD_NUMBER = "CardNumber"
const PROJECT_NOTES = "ProjectNotes"
const PROJECT_ID = "ProjectID"
const PROJECT_SOURCE = "ProjectSource"
const PROJECT_COLOR = "ProjectColor"
const SIGNATURE = "ApprovedBy"
const LAST_UPDATED = "LastUpdated"
const ATTATCHMENTS = "AttatchedFiles"
const VOLENTEER = "VolenteerProjectIndicator"

const EMPTYATTATCHMENT = {"":""}

enum SearchBy {
	Title,
	Description,
	LibraryCard,
}
