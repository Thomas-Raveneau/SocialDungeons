extends Panel

var Highscores: Array = []
var currentHighScore = 0 setget set_highscore

enum HIGHSCORE {
	dungeonName = 1,
	dungeonTimer = 2
}

var saveFilename = "res://save.txt";
var trigger = true;
	
func _ready() -> void:
	load_highscores()
	pass
	
func load_highscores():
	var file = File.new()
	if not file.file_exists(saveFilename): 
		return
	file.open(saveFilename, File.READ)
	currentHighScore = file.get_var()
	file.close()
	pass

func save_highcore():
	var file = File.new()
	file.open(saveFilename, File.WRITE)
	file.store_var(currentHighScore)
	file.close()
	pass
	
func set_highscore(new_value):
	currentHighScore = new_value
	save_highcore()
	pass
#func on_Button_pressed():
#	var dungeon1 = get_node("dungeon1_highscore")
#	var dungeon2 = get_node("dungeon2_highscore")
#	var dungeon3 = get_node("dungeon3_highscore")
#
#	var dungeonName1 = get_Highscore("dungeon1", "dungeon_name");
#	var dungeonTimer1 = get_Highscore("dungeon1", "timer");
#
#	if dungeonName1 && dungeonTimer1:
#		dungeon1.text = dungeonName1 + " : " + dungeonTimer1;
#	else:
#		dungeon1.text = "No highscore";
#
#	var dungeonName2 = get_Highscore("dungeon2", "dungeon_name");
#	var dungeonTimer2 = get_Highscore("dungeon2", "timer");
#
#	if dungeonName2 && dungeonTimer2:
#		dungeon2.text = dungeonName2 + " : " + dungeonTimer2;
#	else:
#		dungeon2.text = "No highscore";
#
#	var dungeonName3 = get_Highscore("dungeon3", "dungeon_name");
#	var dungeonTimer3 = get_Highscore("dungeon3", "timer");
#
#	if dungeonName3 && dungeonTimer3:
#		dungeon3.text = dungeonName3 + " : " + dungeonTimer3;
#	else:
#		dungeon3.text = "No highscore";
#
#func get_Highscore(var section, var key):
#	var file = ConfigFile.new();
#	var error = file.load(saveFilename); 
#
#	if error != OK:
#		return false;
#
#	if file.has_section_key(section, key):
#		return file.get_value(section, key);
#	else:
#		return false;
#
#func on_Button_pressed2():
#	save_Highscore("dungeon3", "dungeon_name", "beach");
#	save_Highscore("dungeon3", "timer", "05:04:03");
#
#func save_Highscore(var section, var key, var value):
#	var file = ConfigFile.new();
#	var error = file.load(saveFilename);
#
#	if error != OK:
#		return false;
#
#	file.set_value(section, key, value);
#	file.save(saveFilename);
#
#func save_Dungeon_Highscore_Config_File(var filename, var section, var key, var value):
#	var file = ConfigFile.new();
#	var error = file.load(filename);
#
#	if error != OK:
#		print("there is error");
#		return false;
#	file.set_value(section, key, value);
#	file.save(filename);
#
#func display_Highscore_Handmade():
#	var dungeon_name = get_node("dungeon_name")
#	var timer = get_node("timer")
#
#	if (trigger):
#		dungeon_name.text = get_Dungeon_Highscore2("res://save/save2.txt", 1, HIGHSCORE.dungeonName);
#		timer.text = get_Dungeon_Highscore2("res://save/save2.txt", 1, HIGHSCORE.dungeonTimer);
#	else:
#		dungeon_name.text = get_Dungeon_Highscore2("res://save/save2.txt", 2, HIGHSCORE.dungeonName);
#		timer.text = get_Dungeon_Highscore2("res://save/save2.txt", 2, HIGHSCORE.dungeonTimer);
#	trigger = !trigger;
#
#func get_Dungeon_Highscore(var file, var dungeon_Section, var key):
#	print(file.get_sections())
#	if file.has_section_key(dungeon_Section, key):
#		return file.get_value(dungeon_Section, key)
#	else:
#		return "sah on t'a bien baisé mon reuf"
#
#func get_Dungeon_Highscore2(var filename, var wanted_Dungeon, var key):
#	var file = File.new();
#	var index = wanted_Dungeon * 4 - 4 + key;
#	var error = file.open(filename, File.READ)
#
#	if (error != OK):
#		return false
#
#	var target_line = "";
#	var i = 0
#
#	while not file.eof_reached():
#		var line = file.get_line();
#
#		if (index == i):
#			target_line = line;
#
#		i += 1;
#	if (target_line == ""):
#		return false;
#	file.close();
#	return target_line;
#
#func save_Highscore_Handmade():
#	var filename = "res://save/save2.txt";
#	var wanted_Dungeon = 1;
#	save_Dungeon_Highscore(filename, wanted_Dungeon, HIGHSCORE.dungeonName, "beach");
#	save_Dungeon_Highscore(filename, wanted_Dungeon, HIGHSCORE.dungeonTimer, "00:25:12");
#
#func save_Dungeon_Highscore(var filename, var wanted_Dungeon, var key, var value):
#	var index = wanted_Dungeon * 4 - 4 + key;
#	var file = File.new();
#
#	var error2 = file.open(filename, File.READ);
#
#	if (error2 != OK):
#		return false;
#	var i = 0;
#	var final_content = "";
#
#	while not file.eof_reached():
#		if (index != i):
#			final_content += file.get_line();
#		else:
#			file.get_line();
#			final_content += value;
#		if not file.eof_reached():
#			final_content += "\n";
#		i += 1;
#	file.close();
#	var error = file.open(filename, File.WRITE);
#	if (error != OK):
#		return false;
#	file.store_string(final_content);
#	file.close();

func _on_ResumePauseButton_pressed() -> void:
	

	pass # Replace with function body.
