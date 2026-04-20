extends "res://Scripts/AISpawner.gd"

var startTime : int
var targetTime : int
var targetValue : int
var easing : float


func _load_new_config(config: ConfigFile):
    spawnLimit = config.get_value("Int", "spawnLimit").value
    spawnPool = config.get_value("Int", "spawnPool").value
    targetTime = config.get_value("Int", "targetTime").value
    targetValue = config.get_value("Int", "targetValue").value
    easing = config.get_value("Float", "easing").value

func _ready() -> void:
    _load_new_config(PopulatedConfig._config)
    PopulatedConfig.configChanged.connnect(_load_new_config)
    super()._ready()
    startTime = Time.get_ticks_msec()





func easeSpawnTime():
    var progress = (Time.get_ticks_msec() - startTime)/1000.0 / targetTime
    return 1.0+ ((targetValue-1.0) * pow(progress, easing))


func _physics_process(delta) -> void:

    if !active:
        return

    spawnTime -= delta


    if spawnTime <= 0:

        if activeAgents < spawnLimit:
            SpawnWanderer()

        spawnTime = easeSpawnTime()
        