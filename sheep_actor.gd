extends Node3D
## Acteur mouton provisoire. Les zones sont des composants indépendants pour
## permettre ensuite un vrai mesh de toison, des masques de coupe et le rig.
signal fleece_changed(remaining: int)

const ZONE_COUNT := 12
var zones: Array[MeshInstance3D] = []
var removed := 0

func _ready() -> void:
    _build_blockout_animal()

func _build_blockout_animal() -> void:
    _ellipsoid("Corps de base", Vector3.ZERO, Vector3(1.15,0.52,0.48), Color(0.50,0.46,0.39))
    _ellipsoid("Tête", Vector3(0.88,0.12,0), Vector3(0.34,0.37,0.28), Color(0.36,0.31,0.27))
    _ellipsoid("Museau", Vector3(1.16,-0.02,0), Vector3(0.18,0.14,0.18), Color(0.22,0.19,0.18))
    for x in [-0.75,-0.25,0.35,0.75]:
        for z in [-0.27,0.27]:
            var leg := MeshInstance3D.new()
            var cyl := CylinderMesh.new()
            cyl.top_radius = 0.055
            cyl.bottom_radius = 0.045
            cyl.height = 0.55
            leg.mesh = cyl
            leg.position = Vector3(x,-0.52,z)
            _apply_material(leg, Color(0.29,0.25,0.22))
            add_child(leg)

    # Panneaux grossiers de démonstration. Le futur asset sera un volume de laine
    # sculpté, segmenté par UV/vertex groups ou géométrie découpable.
    for i in range(ZONE_COUNT):
        var angle := TAU * float(i) / float(ZONE_COUNT)
        var patch := MeshInstance3D.new()
        patch.name = "FleecePatch_%02d" % i
        var sphere := SphereMesh.new()
        sphere.radius = 0.37
        sphere.height = 0.52
        patch.mesh = sphere
        patch.scale = Vector3(1.45,0.82,0.92)
        patch.position = Vector3(-0.12 + cos(angle)*0.08, 0.10 + sin(angle)*0.08, 0)
        patch.rotation.z = angle * 0.13
        _apply_material(patch, Color(0.84,0.82,0.75))
        add_child(patch)
        zones.append(patch)

func _ellipsoid(label: String, pos: Vector3, size: Vector3, color: Color) -> void:
    var node := MeshInstance3D.new()
    node.name = label
    var sphere := SphereMesh.new()
    sphere.radius = 0.5
    sphere.height = 1.0
    node.mesh = sphere
    node.position = pos
    node.scale = size
    _apply_material(node, color)
    add_child(node)

func _apply_material(node: MeshInstance3D, color: Color) -> void:
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.roughness = 0.96
    node.material_override = mat

func apply_shear_pass(aim: Vector3) -> Dictionary:
    if removed >= zones.size():
        return {"points": 0, "message": "Toison de démonstration déjà retirée."}
    # Sélection déterministe temporaire. La version professionnelle évaluera le
    # contact réel de l'outil, les lignes de coupe, les recouvrements et les défauts.
    var index := removed
    var zone := zones[index]
    if is_instance_valid(zone):
        var tween := create_tween()
        tween.tween_property(zone, "scale", Vector3.ZERO, 0.18)
        tween.tween_callback(zone.queue_free)
    removed += 1
    fleece_changed.emit(get_remaining_sections())
    return {"points": 50, "message": "Zone %d/%d retirée — score provisoire." % [removed, ZONE_COUNT]}

func get_remaining_sections() -> int:
    return maxi(0, zones.size() - removed)
