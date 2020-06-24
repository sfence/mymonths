
-- default model

local default_clouds_generations = {
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
      temperature_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -150,
        upper_steepness = 1.2,
        upper_border = 150,
      },
      humidity_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -50,
        upper_steepness = 1.2,
        upper_border = 150,
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
local default_wind_generations = {
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
      temperature_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -150,
        upper_steepness = 1.2,
        upper_border = 150,
      },
      humidity_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -50,
        upper_steepness = 1.2,
        upper_border = 150,
      },
    },
    
    speed = {min=0,max=50},
    angle = {min=0,max=359},
  },
};

local default_weather_generations = {
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
      temperature_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -150,
        upper_steepness = 1.2,
        upper_border = 150,
      },
      humidity_presence = {
        probability_offset = 0,
        probability_multiplier = 1,
        lower_steepness = 1.2,
        lower_border = -50,
        upper_steepness = 1.2,
        upper_border = 150,
      },
    },
    
    temperature = {min=0,max=0},
    humidity = {min=0,max=0},
    fallings = {
      {
        precipitation = {min=0, max=0},
        water_precipitation = false,
        darken_color = {
          depend_color = true,
          r = {min = 0x00, max = 0x00},
          g = {min = 0x00, max = 0x00},
          b = {min = 0x00, max = 0x00},
          a = {min = 0x00, max = 0x00},
        },
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

mymonths.weather_model = {
    year_daynight = {amplitude=0.4,offset=0, phase=1.5*math.pi},
    year_humidity = {amplitude=10,offset=50, phase=0.5*math.pi},
    day_humidity = {amplitude=25,offset=50, phase=0.5*math.pi},
    year_temp = {amplitude=40,offset=0, phase=1.5*math.pi},
    day_temp = {amplitude=10,offset=0, phase=1.5*math.pi},
    
    clouds_generations = default_clouds_generations,
    wind_generations = default_wind_generations,
    weather_generations = default_weather_generations,
  };


-- load model from file if posible
local this_mod_path = minetest.get_modpath(minetest.get_current_modname());

local function dofile_if_exists(filename)
  local f = loadfile(filename);
  if (f~=nil) then
    return f();
  end
  
  return;
end

if (mymonths.weather_model_file~=nil) then
  local weather_model_file = this_mod_path.."/"..mymonths.weather_model_file;
  
  dofile_if_exists(weather_model_file)

  minetest.log("warning", "weather model: "..dump(mymonths.weather_model));
end


