-- weathers definitions

-- weather genration logic
-- 
-- 1. -> generate clouds depend on year time
-- 2. -> generate wind depends on year and day time
-- 3. -> generate other weather parameters depends on clouds, wind, year time etc...
--    -> done by calculate probability of all weathers and select one of them after it

local clouds_generations = {};
local wind_generations = {};
local weather_generations = {};

local function random_range(range_def, random_value)
  if type(range_def)~="table" then
    return range_def;
  end
  
  if (random_value==nil) then
    random_value = default.random_generator:next(0,16777215)/16777215.0;
  end
  
  return range_def.min + (range_def.max-range_def.min)*random_value;
end

local function random_color(color_def)
  local random_value = nil;
  if (color_def.depend_color==true) then
    random_value = default.random_generator:next(0,16777215)/16777215.0;
  end
    
  local color = {
    r = random_range(color_def.r, random_value),
    g = random_range(color_def.g, random_value),
    b = random_range(color_def.b, random_value),
    a = random_range(color_def.a, random_value),
  };
  
  return color;
end

local function random_select(generations, presence_callback, weather_old, weather_new)
  local chance_sum = 0;
  local chances = {};
  local index = 1;
  
  for index, variant in ipairs(generations) do
    local old_chance = mymonths.weather_presence_chance(weather_old, variant.old_presence, 0);
    local new_chance = presence_callback(weather_old, weather_new, variant);
    local chance = old_chance * new_chance;
    
    chance_sum = chance_sum + chance;
    table.insert(chances, chance);
  end
  
  local random_chance = default.random_generator:next(0,16777215)/16777215.0;
  random_chance = random_chance * chance_sum;
  
  for index,value in pairs(chances) do
    random_chance = random_chance - value;
    if (random_chance<=0) then
      return generations[index];
    end
  end
  
  return generations[index];
end

local function clouds_presence_callback(weather_old, weather_new, variant)
  local old_chance = mymonths.weather_presence_chance(weather_old, variant.old_presence, 0);
  local new_chance = mymonths.clouds_presence_chance(variant.new_presence, 0);
  return old_chance * new_chance;
end

local function generate_clouds(weather_old)
  local clouds_select = random_select(clouds_generations, clouds_presence_callback, weather_old, nil);
  
  local clouds = {
    density = random_range(clouds_select.density, nil),
    color = random_color(clouds_select.color),
    ambient = random_color(clouds_select.ambient),
    height = math.floor(random_range(clouds_select.height, nil)+0.5),
    thickness = math.floor(random_range(clouds_select.thickness, nil)+0.5),
  };
  
  return clouds;
end

local function wind_presence_callback(weather_old, weather_new, variant)
  local old_chance = mymonths.weather_presence_chance(weather_old, variant.old_presence, 0);
  local new_chance = mymonths.wind_presence_chance(variant.new_presence, 0);
  return old_chance * new_chance;
end

local function generate_wind(weather_old, weather_new)
  local wind_select = random_select(wind_generations, wind_presence_callback, weather_old, weather_new);
  
  weather_new.wind_speed = random_range(wind_select.speed, nil);
  weather_new.wind_angle = random_range(wind_select.angle, nil);
  local angle_rad = (weather_new.wind_angle/180.0)*math.pi;
  weather_new.wind = {
    x = math.sin(angle_rad)*weather_new.wind_speed,
    z = math.cos(angle_rad)*weather_new.wind_speed,
  };
  
  return weather_new;
end

local function weather_presence_callback(weather_old, weather_new, variant)
  local old_chance = mymonths.weather_presence_chance(weather_old, variant.old_presence, 0);
  local new_chance = mymonths.weather_presence_chance(weather_new, variant.new_presence, 0);
  return old_chance * new_chance;
end

local function generate_weather(weather_old)
  local weather_new = {
    clouds = generate_clouds(weather_old);
  };
  weather_new = generate_wind(weather_old, weather_new);
  
  --minetest.log("warning", "random weather: "..dump(weather_generations))
  local weather_select = random_select(weather_generations, weather_presence_callback, weather_old, weather_new);
  --minetest.log("warning", "sel weather: "..dump(weather_select))
  
  weather_new.temperature = random_range(weather_select.temperature, nil);
  weather_new.humidity = random_range(weather_select.humidity, nil);
  
  weather_new.fallings = table.copy(weather_select.fallings);
  for key, falling in pairs(weather_new.fallings) do
    --minetest.log("warning", "falling: "..dump(falling))
    falling.precipitation = random_range(falling.precipitation, nil);
  end
  
  weather_new.lightning_density = random_range(weather_select.lightning_density, nil);
  weather_new.update_interval = weather_select.update_interval;
  weather_new.time_start = random_range(weather_select.time_start, nil);
  weather_new.time_end = random_range(weather_select.time_end, nil);
  
  weather_new.stable = true;
  
  return weather_new;
end

local function callback_get_new_weather(weather_old)
  return generate_weather(weather_old);
end

WeatherWithWind.callback_get_new_weather = callback_get_new_weather;

clouds_generations = {
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
          depend_color = false,
          r = 0x00,
          g = 0x00,
          b = 0x00,
          a = 0xff,
        },
      height = {min=25,max=200},
      thickness = {min=1,max=128},
  },
};
wind_generations = {
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

weather_generations = {
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
    
    temperature = {min=0,max=0},
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
  },
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
