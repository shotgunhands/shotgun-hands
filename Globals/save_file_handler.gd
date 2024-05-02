extends Node

# delete the old savegame and write the game data to a new save file
func save_game(dict :Dictionary):
	DirAccess.remove_absolute("user://save_game.dat")
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_string(str(dict))
	file.close()

# loads and returns the savegame. If there is none, returns null
func load_game():
	if not DirAccess.dir_exists_absolute("user://save_game.dat"):
		Logger.log("no savegame exists")
		return null
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var file_c = file.get_as_text()
	var dict = JSON.parse_string(file_c)
	file.close()
	return dict
