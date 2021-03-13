extends StaticBody

class_name RuntimeSpatialGizmo

#Use this as a child of the node you wish to move

export var drag_direction = Vector3.UP


var dragged = false
var clicked_position = Vector3.ZERO
var click_plane
var original_transform = null

onready var _dragged_object = get_parent().get_parent()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(dragged and !Input.is_mouse_button_pressed(BUTTON_LEFT)):
		dragged = false
	if(dragged):
		var cam = get_viewport().get_camera()
		var mp = get_viewport().get_mouse_position()

		var from = cam.project_ray_origin(mp)
		var dir = cam.project_ray_normal(mp)
		var intersection_of_movement_point = click_plane.intersects_ray(from,dir)
		if intersection_of_movement_point == null:
			#Don't move if its exactly parallel to plane
			return
		var dist = intersection_of_movement_point - clicked_position
		var displacement = dist.project(drag_direction)
		_dragged_object.global_transform = original_transform
		_dragged_object.translate_object_local(displacement)



func _on_UpArrow_input_event(camera, event, click_position, click_normal, shape_idx):
	if(event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed):
		dragged = true
		#Get the plane on which to move the object on
		var mp = get_viewport().get_mouse_position()
		var vertical_vector = camera.project_ray_normal(mp).normalized().cross(drag_direction)
		var plane_normal = drag_direction.cross(vertical_vector)
		click_plane = Plane(plane_normal, 0)
		
		#Get the distance to the click position
		#Also, apparently I suck at vector math so I guess I will get godot to do the math for me
		var dist_to_click_point = click_plane.distance_to(click_position)
		click_plane = Plane(plane_normal, dist_to_click_point)
		

		clicked_position = click_position
		original_transform = _dragged_object.global_transform

		
	
