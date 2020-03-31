--Settings
mymonths = {}

--Turn damage on or off. This will make storms and hail cause damage to players
mymonths.damage = false

--You can turn weather off; this will put snow and puddles off too
mymonths.use_weather = true

--Leaves change color in the fall.
mymonths.leaves = true

--Have snow accumulate on the ground
mymonths.snow_on_ground = true

--Puddles appear when raining
mymonths.use_puddles = true

--Flowers die in winter, grown in spring
mymonths.flowers_die = true

--Grass changes color in fall, and spring
mymonths.grass_change = true

-- configuration added by SFENCE
-- length of month in days
mymonths.month_days = 14;

-- length of year in months
mymonths.year_months = 12;

-- true when holidays should be sended to players
mymonths.chat_holidays = true;

-- true when date should be sended to players every morning
mymonths.chat_date = true;

-- month when time should start after game started, values from 1 to year_months
mymonths.start_in_month = 6;


if minetest.get_modpath("lightning") then
   lightning.auto = false
end

local modpath = minetest.get_modpath("mymonths")
local input = io.open(modpath .. "/settings.txt", "r")

if input then

   dofile(modpath .. "/settings.txt")
   input:close()
   input = nil

end

-- added by SFENCE
-- fix configuration
if (mymonths.month_days  ~= 14) or (mymonths.year_months ~= 12) then
  if (mymonths.chat_holidays == true) then
    mymonths.chat_holidays = false;
    minetest.log("warning", "[mymonths] Send holidays via chat is supported only for month of 14 day lenght and year lenght 12 months.")
  end
  if (mymonths.chat_date == true) then
    mymonths.chat_date = false;
    minetest.log("warning", "[mymonths] Send date via chat is supported only for month of 14 day lenght and year lenght 12 months.")
  end
end

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/abms.lua")
dofile(modpath .. "/command.lua")
dofile(modpath .. "/months.lua")

if mymonths.use_weather == true then
  if minetest.get_modpath("weather_with_wind") then
    dofile(modpath .. "/weather_math.lua")
    dofile(modpath .. "/weather_with_wind.lua")
  else
    dofile(modpath .. "/weather.lua")
  end
else
  mymonths.snow_on_ground = false
  mymonths.use_puddles = false
end

if mymonths.snow_on_ground == false then
   minetest.register_alias("mymonths:snow_cover_1", "air")
   minetest.register_alias("mymonths:snow_cover_2", "air")
   minetest.register_alias("mymonths:snow_cover_3", "air")
   minetest.register_alias("mymonths:snow_cover_4", "air")
   minetest.register_alias("mymonths:snow_cover_5", "air")
end

if mymonths.use_puddles == false then
   minetest.register_alias("mymonths:puddle", "air")
end

if mymonths.grass_change == true then
   dofile(modpath .. "/grass.lua")
end

if mymonths.leaves == true then
   dofile(modpath .. "/leaves.lua")
else
   minetest.register_alias("mymonths:leaves_pale_green", "default:leaves")
   minetest.register_alias("mymonths:leaves_orange", "default:leaves")
   minetest.register_alias("mymonths:leaves_red", "default:leaves")
   minetest.register_alias("mymonths:sticks_default", "default:leaves")
   minetest.register_alias("mymonths:sticks_aspen", "default:aspen_leaves")
   minetest.register_alias("mymonths:leaves_yellow_aspen", "default:aspen_leaves")
   minetest.register_alias("mymonths:leaves_orange_aspen", "default:aspen_leaves")
   minetest.register_alias("mymonths:leaves_red_aspen", "default:aspen_leaves")
end

if mymonths.flowers_die == true then
   dofile(modpath  .. '/pre-flowers.lua')
   dofile(modpath .. "/flowers.lua")
else
   minetest.register_alias('mymonths:deadplant', 'air')
end
