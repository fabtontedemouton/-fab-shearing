extends Node3D
## Point d'entrée. La scène de test reste un greybox : elle sert à valider les systèmes.
const PlayerScene = preload("res://scenes/player.tscn")
const SheepScene = preload("res://scenes/sheep_test.tscn")
const HUDScene = preload("res://scenes/hud.tscn")

var player: CharacterBody3D
var sheep: Node3D
var hud: CanvasLayer
var score := 0

func _ready() -> void:
    _build_test_environment()
    player = PlayerScene.instantiate()
    player.position = Vector3(-2.5, 0.1, 3.0)
    add_child(player)

    sheep = SheepScene.instantiate()
    sheep.position = Vector3(1.4, 0.55, 0.0)
    add_child(sheep)

    hud = HUDScene.instantiate()
    add_child(hud)
    hud.action_requested.connect(_on_action_requested)
    hud.camera_requested.connect(_on_camera_requested)
    hud.set_status("Approche-toi du mouton et entre au poste.")
    hud.set_score(0, 0)

func _build_test_environment() -> void:
    var env_node := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.29, 0.34, 0.34)
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.72, 0.72, 0.68)
    env.ambient_light_energy = 0.65
    env_node.environment = env
    add_child(env_node)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -25, 0)
    sun.light_energy = 1.1
    sun.shadow_enabled = true
    add_child(sun)

    _add_box("Sol de bergerie — greybox", Vector3(0,-0.2,0), Vector3(18,0.4,14), Color(0.34,0.31,0.26))
    _add_box("Mur fond", Vector3(0,2,-7), Vector3(18,4,0.25), Color(0.38,0.36,0.31))
    _add_box("Mur gauche", Vector3(-9,2,0), Vector3(0.25,4,14), Color(0.35,0.33,0.29))
    _add_box("Mur droit", Vector3(9,2,0), Vector3(0.25,4,14), Color(0.35,0.33,0.29))
    _add_box("Toiture", Vector3(0,4.2,0), Vector3(18,0.2,14), Color(0.22,0.25,0.25))
    _add_box("Table de travail — placeholder", Vector3(1.4,0.55,0), Vector3(3.1,0.15,2.0), Color(0.20,0.22,0.21))

func _add_box(label: String, pos: Vector3, size: Vector3, color: Color) -> void:
    var node := MeshInstance3D.new()
    node.name = label
    var mesh := BoxMesh.new()
    mesh.size = size
    node.mesh = mesh
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.9
    node.material_override = material
    node.position = pos
    add_child(node)

func _on_action_requested() -> void:
    if player == null or sheep == null:
        return
    var dist := player.global_position.distance_to(sheep.global_position)
    if dist > 3.0:
        hud.set_status("Trop loin : rapproche-toi du poste.")
        return
    if not player.is_working:
        player.enter_work_mode(sheep.global_position)
        hud.set_status("Poste engagé : vise une zone de toison.")
        return
    var result: Dictionary = sheep.apply_shear_pass(player.get_aim_direction())
    score += int(result.get("points", 0))
    hud.set_status(str(result.get("message", "Passe enregistrée.")))
    hud.set_score(score, sheep.get_remaining_sections())

func _on_camera_requested() -> void:
    if player:
        player.toggle_work_mode()
