extends Node2D

class_name MapGen

@export var TileMapToUse : TileMapLayer
@export var PlayerInst    : Player
@export var LargeGridRes  : int
@export var LargeGridSize : int

@export var North : CollisionShape2D
@export var East  : CollisionShape2D
@export var West  : CollisionShape2D
@export var South : CollisionShape2D

@export var BreakingBarrierPath : String
@export var SpikePath : String

var grid_scale : Vector2


func fill_line(start : Vector2i, direction : Vector2i, length : int, id : int, tile : Vector2i) -> void:
	for i in range(length):
		TileMapToUse.set_cell(start + direction * i, id, tile)

func fill_rect(start : Vector2i, extent :Vector2i, id : int, tile : Vector2i) -> void:
	for i in range(extent.x):
		fill_line(start + Vector2i(i, 0), Vector2i(0, -1), extent.y, id, tile)

# A helper function to compute Manhattan distance as the heuristic
func heuristic(a: Vector2, b: Vector2) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)
	
func sort_by_f_score(a: Array, b: Array) -> int:
	if a[0] > b[0]:
		return true
	return false

# Function to perform Randomized A* Pathfinding
func randomized_a_star(large_scale_grid: Array, start: Vector2i, goal: Vector2i, large_grid_size: int) -> Array:
	var open_list := []  # Priority queue for A* open nodes (using Array as a heap)
	open_list.append([0 + heuristic(start, goal), 0, start])  # [f, g, position]
	var came_from := {}  # To store the path
	var g_score := {start: 0}  # Store the cost from start to current node
	var f_score := {start: heuristic(start, goal)}  # Estimated cost to goal from current node
	var closed_set := {}  # To track visited nodes
	
	while open_list.size() > 0:
		# Pop the node with the smallest f-score (or random bias)
		open_list.sort_custom(sort_by_f_score)
		var current_data = open_list.pop_front()  # [f, g, position]
		var current = current_data[2]
		var current_g = current_data[1]
		
		# If we reach the goal, return the path
		if current == goal:
			var path := []
			var temp := goal
			while temp in came_from:
				path.append(temp)
				temp = came_from[temp]
			path.append(start)
			path.reverse()
			return path
		
		closed_set[current] = true
		
		# Get the neighbors (4-directional)
		var neighbors := [
			Vector2i(current.x - 1, current.y),  # Up
			Vector2i(current.x + 1, current.y),  # Down
			Vector2i(current.x, current.y - 1),  # Left
			Vector2i(current.x, current.y + 1)   # Right
		]
		
		# Filter out invalid neighbors (out of bounds or blocked)
		var valid_neighbors := []
		for neighbor in neighbors:
			if neighbor.x >= 0 and neighbor.x < large_grid_size and neighbor.y >= 0 and neighbor.y < large_grid_size and large_scale_grid[neighbor.x][neighbor.y] != 1:
				valid_neighbors.append(neighbor)
		
		# Randomized exploration of neighbors with a bias towards f(n) minimization
		valid_neighbors.shuffle()  # Shuffle the neighbors to introduce randomness
		
		for neighbor in valid_neighbors:
			if closed_set.has(neighbor):
				continue
			
			var tentative_g_score = current_g + 1  # Assuming each step costs 1

			# If this path to the neighbor is better, update it
			if not g_score.has(neighbor) or tentative_g_score < g_score[neighbor]:
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g_score
				f_score[neighbor] = tentative_g_score + heuristic(neighbor, goal)

				# Push the neighbor into the open list with random bias
				open_list.append([f_score[neighbor], tentative_g_score, neighbor])

	return []  # If no path is found

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var final_res = LargeGridRes * LargeGridSize
	var player_start_pos = PlayerInst.position
	grid_scale = Vector2(TileMapToUse.tile_set.tile_size) * TileMapToUse.scale
	var player_start_tile = Vector2i(floor(player_start_pos / grid_scale))
	var tile_set_id = 1
	var tile_to_use = Vector2i(8, 0)
	
	TileMapToUse.clear()
	PlayerInst.HookablePoints.clear()
	
	var goal_large_grid_pos = Vector2i(randi_range(1, LargeGridSize-1), LargeGridSize-1)
	
	var large_scale_grid = []
	for i in range(LargeGridSize):
		var row = []
		for j in range(LargeGridSize):
			row.append(0)
		large_scale_grid.append(row)
	
	# large scale grid number meanings:
	# 0 filled
	# 1 empty
	# 2 start
	# 3 goal
	# 4 wall top
	# 5 wall right
	# 6 wall bottom
	# 7 wall top
	# 8 spikes
	var path = randomized_a_star(large_scale_grid, Vector2i(0, 0), goal_large_grid_pos, LargeGridSize)
	
	var hook_point_coords = []
	
	for i in range(path.size()):
		var node = path[i]
		if i % 4 == 0:
			hook_point_coords.append(node)
		large_scale_grid[node.x][node.y] = 1
		if i > 1 and randi_range(0, 10) < 2:
			var preceding_node = path[i - 1]
			if preceding_node.y > node.y:
				large_scale_grid[node.x][node.y] = 4
			elif preceding_node.x > node.x:
				large_scale_grid[node.x][node.y] = 5
			elif preceding_node.y < node.y:
				large_scale_grid[node.x][node.y] = 6
			elif preceding_node.x < node.x:
				large_scale_grid[node.x][node.y] = 7
		elif i > 1 and randi_range(0, 10) < 4:
			large_scale_grid[node.x][node.y] = 8
	large_scale_grid[0][0] = 2
	large_scale_grid[goal_large_grid_pos.x][goal_large_grid_pos.y] = 3
	
		
	var lowest_corner  = player_start_tile - Vector2i(LargeGridRes, -LargeGridRes) / 2
	var highest_corner = lowest_corner + Vector2i(final_res, final_res)
	
	var lowest_corner_world  = Vector2(lowest_corner)  * grid_scale
	var highest_corner_world = Vector2(highest_corner) * grid_scale
	West.position  = lowest_corner_world
	South.position = lowest_corner_world
	East.position  = highest_corner_world
	North.position = highest_corner_world
	
	fill_line(lowest_corner - Vector2i(0, -1), Vector2i(1, 0), final_res + 1, tile_set_id, tile_to_use)
	fill_line(lowest_corner - Vector2i(0, -2), Vector2i(1, 0), final_res + 1, tile_set_id, tile_to_use)
	
	fill_line(lowest_corner - Vector2i(1, -2), Vector2i(0, -1), final_res + 3, tile_set_id, tile_to_use)
	fill_line(lowest_corner - Vector2i(2, -2), Vector2i(0, -1), final_res + 4, tile_set_id, tile_to_use)
	
	fill_line(lowest_corner - Vector2i(0, final_res), Vector2i(1, 0),  final_res, tile_set_id, tile_to_use)
	fill_line(lowest_corner - Vector2i(1, final_res + 1), Vector2i(1, 0),  final_res + 3, tile_set_id, tile_to_use)
	
	fill_line(lowest_corner + Vector2i(final_res, 0), Vector2i(0, -1), final_res + 1, tile_set_id, tile_to_use)
	fill_line(lowest_corner + Vector2i(final_res + 1, 2), Vector2i(0, -1), final_res + 3, tile_set_id, tile_to_use)
	
	
	for i in range(LargeGridSize):
		for j in range(LargeGridSize):
			var large_coord = Vector2i(LargeGridRes * i, -LargeGridRes * j)
			if not large_scale_grid[i][j]:
				fill_rect(lowest_corner + large_coord, Vector2i(LargeGridRes, LargeGridRes), tile_set_id, tile_to_use)
			if Vector2i(i, j) in hook_point_coords:
				PlayerInst.HookablePoints.append(
					Vector2( player_start_tile + large_coord ) * grid_scale)
			if large_scale_grid[i][j] == 1:
				var sides = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]
				for side in sides:
					var off_coord = Vector2i(i + side.x, j + side.y)
					if 0 <= off_coord.x and off_coord.x < LargeGridSize and 0 <= off_coord.y and off_coord.y < LargeGridSize:
						if large_scale_grid[i + side.x][j + side.y]:
							continue
					var side_start = (large_coord - Vector2i(LargeGridRes, -LargeGridRes) / 2
									+ Vector2i(LargeGridRes if side.x > 0 else 0, -LargeGridRes if side.y > 0 else 0)
									)
					var direction = Vector2i(abs(side.y), abs(side.x))
					for k in range(LargeGridRes/4):
						var height = randi_range(0, LargeGridRes / 8) * 2
						fill_rect(side_start + k * 4 * Vector2i(direction.x, -direction.y),
							height * -Vector2i(side.x, side.y) + 4 * direction, tile_set_id, tile_to_use)
					
			elif large_scale_grid[i][j] >= 4 and large_scale_grid[i][j] <= 7:
				var scene = load(BreakingBarrierPath)
				var instance := scene.instantiate() as BreakingBarrier
				instance.PlayerInst = PlayerInst
				instance.Threshold  = randf_range(500., 2200.)
				if large_scale_grid[i][j] == 4:
					instance.update(Vector2(LargeGridRes, LargeGridRes / 8) * grid_scale)
					instance.position = (lowest_corner_world
						+ Vector2((i + 0.5) * LargeGridRes,
								 -(j + 0.9375) * LargeGridRes + 1)
								* grid_scale)
				elif large_scale_grid[i][j] == 6:
					instance.update(Vector2(LargeGridRes, LargeGridRes / 8) * grid_scale)
					instance.position = (lowest_corner_world
						+ Vector2((i + 0.5) * LargeGridRes,
								 -(j + 0.0625) * LargeGridRes + 1)
								* grid_scale)
				elif large_scale_grid[i][j] == 5:
					instance.update(Vector2(LargeGridRes, LargeGridRes / 8) * grid_scale)
					instance.position = (lowest_corner_world
						+ Vector2((i + 0.9375) * LargeGridRes,
								 -(j + 0.5) * LargeGridRes + 1)
								* grid_scale)
					instance.rotation = PI * 0.5
				elif large_scale_grid[i][j] == 7:
					instance.update(Vector2(LargeGridRes, LargeGridRes / 8) * grid_scale)
					instance.position = (lowest_corner_world
						+ Vector2((i + 0.0625) * LargeGridRes,
								-(j + 0.5) * LargeGridRes + 1)
								* grid_scale)
					instance.rotation = PI * 0.5
				add_child(instance)
			if large_scale_grid[i][j] == 8: #spikes
				var scene = load(SpikePath)
				# select side
				var sides = [
					Vector2i(0, 1 if j < LargeGridSize - 1 else 0),
					Vector2i(0,-1 if j > 0 else 0),
					Vector2i(1 if i < LargeGridSize - 1 else 0, 0),
					Vector2i(0 if i > 0 else 0, 0)]
				var place_position : Vector2
				var place_rotation := 0. as float
				var side : Vector2i
				var found := false
				while sides.size() > 0:
					side = sides.pick_random()
					if large_scale_grid[i + side.x][j + side.y] == 0:
						place_position = (lowest_corner_world
									+ Vector2((i + max(0, side.x)) * LargeGridRes,
							 				 -(j + max(0, side.y)) * LargeGridRes + 1) * grid_scale)
						if   side.x == 1: place_rotation += 1.5 * PI; place_position.x -= 32
						elif side.x ==-1: place_rotation += 0.5 * PI; place_position.x += 32
						elif side.y == 1: place_rotation += 1.0 * PI; place_position.y += 32
						elif side.y ==-1: place_rotation += 0.0 * PI; place_position.y -= 32
						found = true
						break
					else:
						sides.erase(side)
				
				if not found:
					continue
				for k in range(LargeGridRes):
					var instance := scene.instantiate() as Spike
					instance.PlayerInst = PlayerInst
					instance.position = place_position + Vector2(abs(side.y), -abs(side.x)) * (k + 0.5) * 64
					instance.rotation = place_rotation
					add_child(instance)
	
#	TileMapToUse.update_bitmask_region(lowest_corner, highest_corner)
	for i in range(-2, final_res + 5):
		for j in range(-2, final_res + 5):
			TileMapToUse.set_cells_terrain_connect(
				[lowest_corner + Vector2i(i - 2, -j + 2)], 0, 1
			)
	

func is_field_free(pos : Vector2) -> bool:
	var grid_pos = Vector2i(floor(pos / grid_scale))
	return TileMapToUse.get_cell_source_id(grid_pos) == -1
