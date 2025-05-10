@tool
extends Node

## List of games other than this one, with properties "name", "credits", "launch/play/win/lossCount", "topScore"
var otherGames:Array = []

## Used to control which games to include in tallies.
enum Count {OTHER_GAMES, THIS_GAME, ALL_TOJAM_2025}

#region State reporting
# Use these methods to count when the player starts a game / match / round
# and when they win or lose (if applicable)

# You can optionally report a score with either a win or loss
# to have the highest score tracked.

# reportWin/Loss are no-ops if there is not a round in progress,
# so be sure to call startPlay() at the start of the round.
func startPlay() -> void:
	_playInProgess = true
	_thisGameData["playCount"] += 1
	_trySave()

func recordWin(score:float = 0) -> void:
	if not _playInProgess: return
	_playInProgess = false
	_thisGameData["winCount"] += 1
	_thisGameData["topScore"] = max(score, _thisGameData["topScore"])
	_trySave()

func recordLoss(score:float = 0) -> void:
	if not _playInProgess: return
	_playInProgess = false
	_thisGameData["lossCount"] += 1
	_thisGameData["topScore"] = max(score, _thisGameData["topScore"])
	_trySave()

#endregion

#region Stats queries
# Use these methods to learn about and react to the player's play history
func countGames(mode: Count) -> int:
	var count:int = 0
	if mode == Count.THIS_GAME || mode == Count.ALL_TOJAM_2025:
		count = 1
	if mode == Count.OTHER_GAMES || mode == Count.ALL_TOJAM_2025:
		count += otherGames.size()
	return count;

func countGamesPlayed(mode: Count) -> int:
	return _countGamesPositive("playCount", mode)

func countGamesWon(mode: Count) -> int:
	return _countGamesPositive("winCount", mode)

func countGamesLost(mode: Count) -> int:
	return _countGamesPositive("lossCount", mode)

func countTotalLaunches(mode: Count) -> int:
	return _countTotal("launchCount", mode)

func countTotalPlays(mode: Count) -> int:
	return _countTotal("playCount", mode)

func countTotalWins(mode: Count) -> int:
	return _countTotal("winCount", mode)

func countTotalLosses(mode: Count) -> int:
	return _countTotal("lossCount", mode)

func getTopScore(mode: Count) -> float:
	var top:float = 0
	if mode == Count.THIS_GAME || mode == Count.ALL_TOJAM_2025:
		top = _thisGameData["topScore"]
	if mode == Count.OTHER_GAMES || mode == Count.ALL_TOJAM_2025:
		for game in otherGames:
			top = max(top, game["topScore"])
	return top
#endregion


#region Internals - please don't access/modify these directly

## Title of your game as it should appear in other games / in the index
@export var _displayName:String
## Add one entry per team member who consents to have their name/handle appear in other games - can be left empty
@export var _credits:Array[String]

## Used to match your game in the list, even if two games have the same name 
@export_storage var _gameKey:String

var _thisGameData: Dictionary
var _storageAvailable:bool = false
var _saveData: Dictionary = {}
var _playInProgess:bool = false

const _storageKey = "tojam2025-metagamedata"


func _ready() -> void:
	if Engine.is_editor_hint():
		if not _gameKey:
			randomize()
			_gameKey = str(randi())
		return
	
	var window = JavaScriptBridge.get_interface("window")
	
	if window == null: return
	var storage = window.localStorage
	if storage == null: return
	
	# Not strictly guaranteed available, but we'll call this "good enough"
	_storageAvailable = true
	var loaded = storage.getItem(_storageKey)
	if not loaded || not _validateAndLoadJson(loaded):
		_saveData = {"games":[]}
		
	var found: bool = false
	var games = _saveData["games"]
	for game in games:
		if game == null || typeof(game) != TYPE_DICTIONARY: continue
		if not game.has("key"): continue
		
		if not game.has("launchCount")	|| typeof(game["launchCount"])	!= TYPE_INT:		game["launchCount"]	= 1
		if not game.has("playCount")		|| typeof(game["playCount"])		!= TYPE_INT:		game["playCount"]	= 0
		if not game.has("winCount")		|| typeof(game["winCount"])		!= TYPE_INT:		game["winCount"]		= 0
		if not game.has("lossCount")		|| typeof(game["lossCount"])		!= TYPE_INT:		game["lossCount"]	= 0
		if not game.has("topScore")		|| typeof(game["topScore"])		!= TYPE_FLOAT:	game["topScore"]		= 0
		
		if game["key"] == _gameKey: 
			found = true
			_thisGameData = game
			game["name"] = _displayName
			game["credits"] = _credits
			game["launchCount"] += 1
			#print_debug("Found this game: " + game["name"])
		else:
			var clone:Dictionary = game.duplicate(true)
			if not clone.has("name")		|| typeof(clone["name"]) != TYPE_STRING: 	clone["name"] = "Unknown Game"
			if not clone.has("credits")	|| typeof(clone["credits"]) != TYPE_ARRAY:	clone["credits"] = []
			otherGames.append(clone)
			#print_debug("Found other game: " + clone["name"])
		
		
	
	if not found:
		_thisGameData = {
			"name": _displayName,
			"key": _gameKey,
			"credits": _credits,
			"launchCount": 1,
			"playCount": 0,
			"winCount": 0,
			"lossCout": 0,
			"topScore": 0
		}
		games.append(_thisGameData)
	
	_trySave()

func _validateAndLoadJson(jsonString: String) -> bool:
	var json = JSON.new()
	var error = json.parse(jsonString)
	if error != OK: return false
	
	if json.data == null || typeof(json.data) != TYPE_DICTIONARY: return false
	
	_saveData = json.data
	if not _saveData.has("games"): return false
	var games = _saveData["games"]	
	if games == null || typeof(games) != TYPE_ARRAY: return false
	
	return true

func _trySave() -> void:
	if not _storageAvailable: return
	var window = JavaScriptBridge.get_interface("window")
	window.localStorage.setItem(_storageKey, JSON.stringify(_saveData))

func _countGamesPositive(attribute: String, mode: Count) -> int:
	var count:int = 0
	if mode == Count.THIS_GAME || mode == Count.ALL_TOJAM_2025:
		if _thisGameData[attribute] > 0:
			count = 1
	if mode == Count.OTHER_GAMES || mode == Count.ALL_TOJAM_2025:
		for game in otherGames:
			if game[attribute] > 0:
				count += 1
	return count

func _countTotal(attribute: String, mode: Count) -> int:
	var count:int = 0
	if mode == Count.THIS_GAME || mode == Count.ALL_TOJAM_2025:
		count = _thisGameData[attribute]
	if mode == Count.OTHER_GAMES || mode == Count.ALL_TOJAM_2025:
		for game in otherGames:
			count += game[attribute]
	return count
#endregion
