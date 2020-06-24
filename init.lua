--Settings
mymonths = {}

-- SFENCE: setting from minetest configuration

--Turn damage on or off. This will make storms and hail cause damage to players
mymonths.damage = minetest.setting_getbool("mymonths_damage");
if (mymonths.damage==nil) then
  mymonths.damage = false
end

--You can turn weather off; this will put snow and puddles off too
mymonths.use_weather = minetest.setting_getbool("mymonths_use_weather");
if (mymonths.use_weather==nil) then
  mymonths.use_weather = true
end

--Leaves change color in the fall.
mymonths.leaves = minetest.setting_getbool("mymonths_leaves");
if (mymonths.leaves==nil) then
  mymonths.leaves = true
end

--Have snow accumulate on the ground
mymonths.snow_on_ground = minetest.setting_getbool("mymonths_snow_on_ground");
if (mymonths.snow_on_ground==nil) then
  mymonths.snow_on_ground = true
end

--Puddles appear when raining
mymonths.use_puddles = minetest.setting_getbool("mymonths_use_puddles");
if (mymonths.use_puddles==nil) then
  mymonths.use_puddles = true
end

--Flowers die in winter, grown in spring
mymonths.flowers_die = minetest.setting_getbool("mymonths_flowers_die");
if (mymonths.flowers_die==nil) then
  mymonths.flowers_die = true
end

--Grass changes color in fall, and spring
mymonths.grass_change = minetest.setting_getbool("mymonths_grass_change");
if (mymonths.grass_change==nil) then
  mymonths.grass_change = true
end

-- configuration added by SFENCE
-- length of month in days
mymonths.month_days = tonumber(minetest.setting_get("mymonths_month_days"));
if (mymonths.month_days==nil) then
  mymonths.month_days = 14;
end

-- length of year in months
mymonths.year_months = tonumber(minetest.setting_get("mymonths_year_months"));
if (mymonths.year_months==nil) then
  mymonths.year_months = 12;
end

-- true when holidays should be sended to players
mymonths.chat_holidays = minetest.setting_getbool("mymonths_chat_holidays");
if (mymonths.chat_holidays==nil) then
  mymonths.chat_holidays = true;
end

-- true when date should be sended to players every morning
mymonths.chat_date = minetest.setting_getbool("mymonths_chat_date");
if (mymonths.chat_date==nil) then
  mymonths.chat_date = true;
end

-- weather model
mymonths.weather_model_file = minetest.setting_get("mymonths_weather_model_file");

-- added by SFENCE
-- mod storage support
mymonths.storage = minetest.get_mod_storage();

-- month when time should start after game started, values from 1 to year_months
mymonths.start_in_month = tonumber(minetest.setting_get("mymonths_start_in_month"));
if (mymonths.start_in_month==nil) then
  mymonths.start_in_month = 6;
end

-- add tempsurvive detection
mymonths.have_tempsurvive = false;
if minetest.get_modpath("tempsurvive") then
  mymonths.have_tempsurvive = true;
end

if minetest.get_modpath("lightning") then
   lightning.auto = false
end

local modpath = minetest.get_modpath("mymonths")
--[[
-- disabled, setting from minesfence game is used
local input = io.open(modpath .. "/settings.txt", "r")

if input then

   dofile(modpath .. "/settings.txt")
   input:close()
   input = nil
end
--]]

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

--dofile(modpath .. "/functions.lua")
dofile(modpath .. "/abms.lua")
dofile(modpath .. "/command.lua")
--dofile(modpath .. "/months.lua")

if mymonths.use_weather == true then
  if minetest.get_modpath("weather_with_wind") then
    dofile(modpath .. "/weather_math.lua")
    dofile(modpath .. "/weather_model.lua")
    dofile(modpath .. "/weather_with_wind.lua")
  else
    dofile(modpath .. "/weather.lua")
  end
  dofile(modpath .. "/weather_nodes.lua")
else
  mymonths.snow_on_ground = false
  mymonths.use_puddles = false
end

dofile(modpath .. "/months.lua")

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
