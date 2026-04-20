extends Node

signal configChanged(config: ConfigFile)

var McmHelpers = preload("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")


const MOD_ID = "Populated"
const FILE_PATH = "user://MCM/Populated"
var _config = ConfigFile.new()

func _ready() -> void:
    _config.set_value("Float", "targetValue", {
        "name" = "targetValue",
        "tooltip" = "spawn timer duration to tend toward in seconds",
        "default" = 60,
        "value" = 60,
        "minRange" = 1.0,
        "maxRange" = 5*60
    })

    _config.set_value("Float", "targetTime", {
        "name" = "targetTime",
        "tooltip" = "how long after level load until spawnTime will match the targetValue in seconds(easing must be set to non 0 value to enable",
        "default" = 10*60,
        "value" = 10*60,
        "minRange" = 1.0,
        "maxRange" = 60*60
    })
    _config.set_value("Float", "easing", {
        "name" = "easing",
        "tooltip" = "easing to apply. values < 1 start fast end slow, values > 1 start slow end fast, values == 0 disables easing. will always be targetValue",
        "default" = 0.8,
        "value" = 0.8,
        "minRange" = 0,
        "maxRange" = 4.0
    })

    _config.set_value("Int", "spawnPool", {
        "name" = "spawnPool",
        "tooltip" = "enemies to spawn in total",
        "default" = 10,
        "value" = 25,
        "minRange" = 0,
        "maxRange" = 1000
    })

    _config.set_value("Int", "spawnLimit", {
        "name" = "spawnLimit",
        "tooltip" = "max spawned enemies",
        "default" = 10,
        "value" = 10,
        "minRange" = 0,
        "maxRange" = 1000
    })
    _config.set_value("Bool", "showDebug", {
        "name" = "showDebug",
        "tooltip" = "show debug info(enable the Map HUD option)",
        "default" = false,
        "value" = false
    })
    
    if !FileAccess.file_exists(FILE_PATH + "/config.ini"):
        DirAccess.open("user://").make_dir(FILE_PATH)
        _config.save(FILE_PATH + "/config.ini")
    else:
        McmHelpers.CheckConfigurationHasUpdated(MOD_ID, _config, FILE_PATH + "/config.ini")
        _config.load(FILE_PATH + "/config.ini")


    McmHelpers.RegisterConfiguration(
        MOD_ID,
        "Populated",
        FILE_PATH,
        "Advanced Bot Spawner",
        {
         "/config.ini" = updateSignal
        }
    )



func updateSignal(config:ConfigFile):
    
    configChanged.emit(config)