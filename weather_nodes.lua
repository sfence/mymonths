
--Puddle node
local puddle_box = {
	type  = "fixed",
	fixed = {
		{-0.1875, -0.5, -0.375, 0.125, -0.4875, 0.3125},
		{-0.25, -0.5, -0.3125, 0.3125, -0.4925, 0.25},
		{-0.3125, -0.5, -0.1875, 0.375, -0.4975, 0.1875},
	}
}

minetest.register_node("mymonths:puddle", {
	tiles = {"weather_puddle.png"},
	drawtype = "nodebox",
	paramtype = "light",
	pointable = false,
	buildable_to = true,
	alpha = 50,
	node_box = puddle_box,
	selection_box = puddle_box,
	groups = {not_in_creative_inventory = 1, crumbly = 3, attached_node = 0, falling_node = 1},
	drop = "",
})

--Snow Nodes
local snow = {
	{"mymonths:snow_cover_1","1", -0.4},
	{"mymonths:snow_cover_2","2", -0.2},
	{"mymonths:snow_cover_3","3", 0},
	{"mymonths:snow_cover_4","4", 0.2},
	{"mymonths:snow_cover_5","5", 0.5},
}
for i in ipairs(snow) do

	local itm = snow[i][1]
	local num = snow[i][2]
	local box = snow[i][3]

	minetest.register_node(itm, {
		tiles = {"weather_snow_cover.png"},
		drawtype = "nodebox",
		paramtype = "light",
		buildable_to = true,
		walkable = false,
		node_box = {
			type  = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, box, 0.5}
		},
		selection_box = {
			type  = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, box, 0.5}
		},
		groups = {not_in_creative_inventory = 0, crumbly = 3, attached_node = 0, falling_node = 1},
		drop = "default:snow " .. num,
	})
end
