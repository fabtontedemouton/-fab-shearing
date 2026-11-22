extends Node3D

const SheepScript = preload("res://scripts/sheep.gd")
const PlayerScript = preload("res://scripts/player.gd")

var player: CharacterBody3D
var sheep: Array[Node3D] = []
var held := {"up": false, "down": false, "left": false, "right": false}
var score := 0
var shorn_count := 0
var active_sheep: Node3D
var shearing := false
var ui_label: Label
var target_label: Label
var shear_button: Button

func _ready() -> void:
    _make_world()
    _make_player()
    _make_flock()
    _make_ui()
    _refresh_ui()

func _make_world() -> void:
    var ground := MeshInstance3D.new()
    var plane := PlaneMesh.new()
    plane.size = Vector2(48, 48)
    ground.mesh = plane
    var grass := StandardMaterial3D.new()
    grass.albedo_color = Color(0.30, 0.43, 0.23)
    ground.material_override = grass
    add_child(ground)

    var ground_body := StaticBody3D.new()
    ground_body.position.y = -0.1
    var ground_collision := CollisionShape3D.new()
    var ground_shape := BoxShape3D.new()
    ground_shape.size = Vector3(48, 0.2, 48)
    ground_collision.shape = ground_shape
    ground_body.add_child(ground_collision)
    add_child(ground_body)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-52, -28, 0)
    sun.light_energy = 1.15
    add_child(sun)

    var env := WorldEnvironment.new()
    var environment := Environment.new()
    environment.background_mode = Environment.BG_SKY
    environment.sky = Sky.new()
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.72, 0.78, 0.83)
    environment.ambient_light_energy = 0.7
    env.environment = environment
    add_child(env)

    # Simple wooden race rails to make the first shearing yard readable.
    for z in [-5.0, 5.0]:
        for x in range(-5, 6):
            _make_post(Vector3(float(x), 0.65, z))
    for x in [-5.0, 5.0]:
        for z in range(-5, 6):
            _make_post(Vector3(x, 0.65, float(z)))
    for z in [-5.0, 5.0]:
        var rail := MeshInstance3D.new()
        var box := BoxMesh.new()
        box.size = Vector3(10.5, 0.14, 0.14)
        rail.mesh = box
        rail.position = Vector3(0, 1.05, z)
        var wood := StandardMaterial3D.new()
        wood.albedo_color = Color(0.34, 0.22, 0.12)
        rail.material_override = wood
        add_child(rail)

func _make_post(pos: Vector3) -> void:
    var post := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = Vector3(0.16, 1.3, 0.16)
    post.mesh = mesh
    post.position = pos
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.38, 0.25, 0.14)
    post.material_override = mat
    add_child(post)

func _make_player() -> void:
    player = CharacterBody3D.new()
    player.set_script(PlayerScript)
    player.position = Vector3(0, 0.1, 3.4)
    add_child(player)

func _make_flock() -> void:
    for i in range(6):
        var animal := Node3D.new()
        animal.set_script(SheepScript)
        animal.position = Vector3(-3.6 + float(i % 3) * 2.8, 0, -2.2 + float(i / 3) * 2.0)
        add_child(animal)
        sheep.append(animal)

func _make_ui() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)

    var panel := PanelContainer.new()
    panel.position = Vector2(18, 16)
    panel.custom_minimum_size = Vector2(310, 88)
    layer.add_child(panel)
    ui_label = Label.new()
    ui_label.add_theme_font_size_override("font_size", 22)
    panel.add_child(ui_label)

    target_label = Label.new()
    target_label.position = Vector2(350, 22)
    target_label.add_theme_font_size_override("font_size", 22)
    target_label.text = "Approche-toi d'un mouton"
    layer.add_child(target_label)

    _add_move_button(layer, "▲", Vector2(112, 505), "up")
    _add_move_button(layer, "▼", Vector2(112, 625), "down")
    _add_move_button(layer, "◀", Vector2(48, 565), "left")
    _add_move_button(layer, "▶", Vector2(176, 565), "right")

    shear_button = Button.new()
    shear_button.text = "TONDRE"
    shear_button.position = Vector2(1000, 535)
    shear_button.size = Vector2(220, 115)
    shear_button.add_theme_font_size_override("font_size", 30)
    shear_button.button_down.connect(_start_shearing)
    shear_button.button_up.connect(_stop_shearing)
    layer.add_child(shear_button)

    var hint := Label.new()
    hint.text = "Déplace-toi avec les flèches • Maintiens TONDRE près d'un mouton"
    hint.position = Vector2(350, 665)
    hint.add_theme_font_size_override("font_size", 17)
    layer.add_child(hint)

func _add_move_button(layer: CanvasLayer, caption: String, pos: Vector2, key: String) -> void:
    var button := Button.new()
    button.text = caption
    button.position = pos
    button.size = Vector2(58, 58)
    button.add_theme_font_size_override("font_size", 25)
    button.button_down.connect(func(): held[key] = true)
    button.button_up.connect(func(): held[key] = false)
    layer.add_child(button)

func _process(delta: float) -> void:
    if player:
        var x := float(held["right"]) - float(held["left"])
        var z := float(held["down"]) - float(held["up"])
        player.move_vector = Vector2(x, z).normalized() if Vector2(x, z).length() > 1.0 else Vector2(x, z)
    active_sheep = _nearest_sheep()
    if active_sheep:
        var distance := player.global_position.distance_to(active_sheep.global_position)
        target_label.text = "Mouton à %.1f m  •  %s" % [distance, "TONDU" if active_sheep.is_shorn else "À tondre"]
        shear_button.disabled = distance > 2.1 or active_sheep.is_shorn
    else:
        target_label.text = "Approche-toi d'un mouton"
    if shearing and active_sheep and player.global_position.distance_to(active_sheep.global_position) <= 2.1:
        active_sheep.shear(delta * 0.34)
        if active_sheep.shear_progress >= 1.0:
            shearing = false
            score += 100
            shorn_count += 1
            _refresh_ui()

func _nearest_sheep() -> Node3D:
    var nearest: Node3D = null
    var best := 999.0
    for animal in sheep:
        if not animal.is_shorn:
            var d := player.global_position.distance_to(animal.global_position)
            if d < best:
                best = d
                nearest = animal
    return nearest

func _start_shearing() -> void:
    shearing = true

func _stop_shearing() -> void:
    shearing = false

func _refresh_ui() -> void:
    ui_label.text = "FAB SHEARING  |  FRANCE\\nMoutons tondus : %d / %d\\nRecette de la journée : %d €" % [shorn_count, sheep.size(), score]
