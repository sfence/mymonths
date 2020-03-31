-- weathers definitions

-- weather genration logic
-- 
-- 1. -> generate clouds depend on year time
-- 2. -> generate wind depends on year and day time
-- 3. -> generate other weather parameters depends on clouds, wind, year time etc...
--    -> done by calculate probability of all weathers and select one of them after it

local function callback_get_new_weather(weather_old)
  
end

local clouds_generations = {
  {
    name = "default",
    old_presence = {
      basic_chance = 1,
    },
    new_presence = {
      basic_chance = 1,
      year_time_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -2,
        upper_steepness = 1.2,
        upper_border = 14,
      },
    },
    
    density = {min = 0, max = 1},
    color = {--#fff0f0e5
          depend_color = true,
          r = {min = 0xf0, max = 0xf0},
          g = {min = 0xf0, max = 0xf0},
          b = {min = 0xff, max = 0xff},
          a = {min = 0xe5, max = 0xe5},
        },
      ambient = {--#000000,
          depend_color = true,
          r = 0x00,
          g = 0x00,
          b = 0x00,
          a = 0xff,
        },
      height = {min=25,max=200},
      thickness = {min=1,max=128},
  },
};
local wind_generations = {
  {
    name = "default",
    old_presence = {
      basic_chance = 1,
    },
    new_presence = {
      basic_chance = 1,
      year_time_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -2,
        upper_steepness = 1.2,
        upper_border = 14,
      },
      day_time_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -2,
        upper_steepness = 1.2,
        upper_border = 3,
      },
    },
    
    speed = {min=0,max=50},
    angle = {min=0,max=359},
  },
};

local weather_generations = {
    name = "default",
    old_presence = {
      basic_chance = 1,
    },
    new_presence = {
      basic_chance = 1,
      year_time_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -2,
        upper_steepness = 1.2,
        upper_border = 14,
      },
      day_time_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -2,
        upper_steepness = 1.2,
        upper_border = 3,
      },
    },
    
    temperature = {min=0,mnax=0},
    humidity = {min=0,max=0},
    fallings = {
      {
        precipitation = {min=0, max=0},
        water_precipitation = false,
        downfalls = {},
      },
    },
    
    lightning_density = {min=0,max=0},
    
    update_interval = 10,
    
    time_start = {min=100,max=100},
    time_end = {min=600,max=600},
    
    stable = true,
  };

--Sets the weather types for each month
local t = 0

minetest.register_globalstep(function(dtime)

	local month = mymonths.month_counter

	t = t + dtime

	if t < 5 then
		return
	end

	t = 0

	if minetest.get_modpath("lightning") then
		if mymonths.weather == "storm" then
		lightning.strike()
		end
	end

	if mymonths.weather ~= "clear" then

		if math.random(1, 100) == 1 then

			mymonths.weather = "clear"
		end
	else

		-- January
		if tonumber(month) == 1 then

			if math.random(1, 2000) == 1 then
				mymonths.weather = "snow"

			elseif math.random(1, 5000) == 1 then
				mymonths.weather = "snowstorm"
			end

		-- February
		elseif tonumber(month) == 2 then

			if math.random(1, 1000) == 1 then
				mymonths.weather = "snow"

			elseif math.random(1, 5000) == 1 then
				mymonths.weather = "snowstorm"

			elseif math.random(1, 5000) == 1 then
				mymonths.weather = "hail"
			end

		-- March
		elseif tonumber(month) == 3 then

			if math.random(1, 1000) == 1 then
				mymonths.weather = "rain"

			elseif math.random(1, 2500) == 2 then
				mymonths.weather = "snow"

			elseif math.random(1, 5000) == 1 then
				mymonths.weather = "hail"
			end

		-- April
		elseif tonumber(month) == 4 then

			if math.random(1, 1000) == 1 then
				mymonths.weather = "rain"
			end

		-- May
		elseif tonumber(month) == 5 then

			if math.random(1, 1500) == 1 then
				mymonths.weather = "rain"

			elseif math.random(1, 5000) == 1 then
				mymonths.weather = "storm"
			end

		-- June
		elseif 	tonumber(month) == 6 then

			if math.random(1, 5000) == 1 then
				mymonths.weather = "rain"

			elseif math.random(1, 5000) == 1 then
				mymonths.weather = "storm"
			end

		-- July
		elseif tonumber(month) == 7 then

			if math.random(1, 5000) == 1 then
				mymonths.weather = "rain"

			elseif math.random(1, 5000) == 1 then
				mymonths.weather = "storm"
			end

		-- August
		elseif 	tonumber(month) == 8 then

			if math.random(1, 5000) == 1 then
				mymonths.weather = "rain"

			elseif math.random(1, 5000) == 1 then
				mymonths.weather = "storm"
			end

		-- September
		elseif tonumber(month) == 9 then

			if math.random(1, 1500) == 1 then
				mymonths.weather = "rain"

			elseif math.random(1, 2500) == 1 then
				mymonths.weather = "storm"
			end

		-- October
		elseif tonumber(month) == 10 then

			if math.random(1, 1000) == 1 then
				mymonths.weather = "rain"

			elseif math.random(1, 2500) == 1 then
				mymonths.weather = "storm"
			end

		-- November
		elseif tonumber(month) == 11 then

			if math.random(1, 1000) == 1 then
				mymonths.weather = "rain"

			elseif math.random(1, 2000) == 2 then
				mymonths.weather = "snow"
			end

		-- December
		elseif tonumber(month) == 12 then

			if math.random(1, 2500) == 1 then
				mymonths.weather = "rain"

			elseif math.random(1, 1000) == 1 then
				mymonths.weather = "snow"

			elseif math.random(1, 5000) == 1 then
				mymonths.weather = "hail"
			end
		end
	end
end)
