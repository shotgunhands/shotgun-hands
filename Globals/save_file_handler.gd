extends Node

const SAVE_PATH = "user://save_game.dat"
const DEFAULT_SAVE : Dictionary = {
	"money_dollars" : 0,
	"levels" : {
		# Any level is set to true after it is completed.
		1 : false,
		2 : false
	},
	# Upgrades items and detriments
	"upgrades" : {},
	"detriments" : {},
	"side_quests" : {}
	
}



# delete the old savegame and write the game data to a new save file
func save_game(dict: Dictionary):
	if DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(str(dict))
	file.close()

# loads and returns the savegame. If there is none, returns null
func load_game():
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		Logger.log("no savegame exists")
		return null
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var file_c = file.get_as_text()
	var dict = JSON.parse_string(file_c)
	file.close()
	return dict

# Creates a new game file dictionary and saves it.
func new_save_file():
	pass
