
-- Save table to file
function mymonths.save_table()

	local data = mymonths
	local f, err = io.open(minetest.get_worldpath() .. "/mymonths_data", "w")

	if err then
		return err
	end

	f:write(minetest.serialize(data))
	f:close()
end

-- Reads saved file
function mymonths.read_mymonths()

	local f, err = io.open(minetest.get_worldpath() .. "/mymonths_data", "r")
	local data = minetest.deserialize(f:read("*a"))

	f:close()

	return data
end

-- Saves the table every 10 seconds
local tmr = 0

minetest.register_globalstep(function(dtime)

	tmr = tmr + dtime

	if tmr >= 10 then

		tmr = 0

		mymonths.save_table()
	end
end)

-- Check to see if file exists and if not sets default values.
local f, err = io.open(minetest.get_worldpath().."/mymonths_data", "r")

if f == nil then

	mymonths.day_counter = 1
	mymonths.month_counter = mymonths.start_in_month
  if (mymonths.chat_date==true) then
	  mymonths.month = "June"
  end
	mymonths.weather = "clear"
	mymonths.day_name = "Monday"
else
  local load_data = mymonths.read_mymonths();
	mymonths.day_counter = load_data.day_counter
	mymonths.month_counter = load_data.month_counter
	mymonths.month = load_data.month
	mymonths.weather = load_data.weather
	mymonths.day_name = load_data.day_name
end
