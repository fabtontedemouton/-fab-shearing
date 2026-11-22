extends Node3D

var is_shorn := false
var shear_progress := 0.0
var fleece_nodes: Array[MeshInstance3D] = []
var body_node: MeshInstance3D

func _ready() -> void:
    var body_mesh := SphereMesh.new()
    body_mesh.radius = 0.62
    body_mesh.height = 1.05
    body_node = MeshInstance3D.new()
    body_node.mesh = body_mesh
    body_node.scale = Vector3(1.25, 0.88, 0.78)
    body_node.position.y = 0.82
    var body_mat := StandardMaterial3D.new()
    body_mat.albedo_color = Color(0.91, 0.89, 0.82)
    body_node.material_override = body_mat
    add_child(body_node)

    # Individual wool tufts give the flock a visible fleece silhouette.
    for i in range(18):
        var tuft := MeshInstance3D.new()
        var mesh := SphereMesh.new()
        mesh.radius = 0.24
        mesh.height = 0.34
        tuft.mesh = mesh
        var angle := float(i) * TAU / 18.0
        tuft.position = Vector3(cos(angle) * 0.48, 0.94 + sin(float(i) * 2.1) * 0.16, sin(angle) * 0.34)
        tuft.scale = Vector3(1.0, 0.9, 1.0)
        var wool := StandardMaterial3D.new()
        wool.albedo_color = Color(0.96, 0.94, 0.87)
        tuft.material_override = wool
        add_child(tuft)
        fleece_nodes.append(tuft)

    var head := MeshInstance3D.new()
    var hm := SphereMesh.new()
    hm.radius = 0.25
    hm.height = 0.48
    head.mesh = hm
    head.position = Vector3(0, 0.92, -0.72)
    var face := StandardMaterial3D.new()
    face.albedo_color = Color(0.42, 0.34, 0.29)
    head.material_override = face
    add_child(head)

    for x in [-0.32, 0.32]:
        for z in [-0.25, 0.25]:
            var leg := MeshInstance3D.new()
            var lm := CylinderMesh.new()
            lm.top_radius = 0.055
            lm.bottom_radius = 0.045
            lm.height = 0.48
            leg.mesh = lm
            leg.position = Vector3(x, 0.28, z)
            var dark := StandardMaterial3D.new()
            dark.albedo_color = Color(0.25, 0.23, 0.21)
            leg.material_override = dark
            add_child(leg)

func shear(amount: float) -> void:
    if is_shorn:
        return
    shear_progress = minf(1.0, shear_progress + amount)
    var visible_count := int(ceil((1.0 - shear_progress) * float(fleece_nodes.size())))
    for i in range(fleece_nodes.size()):
        fleece_nodes[i].visible = i < visible_count
    if shear_progress >= 1.0:
        is_shorn = true
        var short_mat := StandardMaterial3D.new()
        short_mat.albedo_color = Color(0.60, 0.57, 0.51)
        body_node.material_override = short_mat
