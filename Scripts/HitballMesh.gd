extends MeshInstance2D

@onready var radius: float = self.get_parent().get_radius()
@export var iteration: float = 20.

func _ready() -> void:
	
	self.radius = radius
	
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var verts = PackedVector2Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	verts.append(Vector2(0, 0))
	uvs.append(Vector2(.5, .5))
	
	for i in range(iteration):
		var angle = 2 * PI / iteration * i
		var cord = self.radius * Vector2(cos(angle), sin(angle))
		verts.append(cord)
		uvs.append((cord / self.radius + Vector2(1., 1.)) / 2.)
		
		if i > 0:
			indices.append(0)
			indices.append(i)
			indices.append(i + 1)
	
	indices.append(0)
	indices.append(iteration)
	indices.append(1)
	
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_INDEX] = indices

	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	ResourceSaver.save(mesh, "res://Meshes/Hitball.tres", ResourceSaver.FLAG_COMPRESS)
