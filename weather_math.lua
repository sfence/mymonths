
-- get normalized year time
mymonths.normalized_year_time = function()
  return    (mymonths.month_counter/mymonths.year_months)*12
          + (mymonths.day_counter/mymonth.month_days);
end

-- 
-- mymonths probability function
--
-- max_probability*abs(1/(1+lower_steepness^(-x+lower_border))    + 1/(1+upper_steepness^(x-upper_border)) - 1)
-- 
-- probabality in lower_border and upper_border is 0.5, 
-- between lower_border and upper_border probability increase to 1, 
-- outside borders probability is decrease to 0,
-- steepnees of decrease and increase is done by lower_steepness and upper_steepness.
-- when lower_steepness < upper_steepness, function select area where vegetation can be found
-- when lower_steepness > upper_steepness, function select area where vegetation cannot be found
-- lower_steepness and upper_steepness have to be bigger then 1, values near to 1 means more gradually steepness.
-- use some program to show function graph to see probability changes
-- x is value of parameter in location
-- max_probability have to be from 0 to 1, 1 if not used, lower when you want to limit max probability.
-- setting lower_steepness and upper_steepness and max_probability to 1, disable probability sensitivity to x
-- all function parameters are stored 
-- in settings table (max_probability, lower_steepness, lower_border, upper_steepness, upper_border)
-- x is stored in actual_value fucntion parameter

-- lower_steepness -> function parameter
-- lower_border -> function parameter
-- upper_steepness -> function parameter
-- upper_border -> function parameter
-- probability_multiplier -> function parameter
-- probability_offset -> function parameter

function mymonths.probability_function(presence, actual_value)
  local first_part = 1/(1+presence.lower_steepness^(-actual_value+presence.lower_border));
  local second_part = 1/(1+presence.upper_steepness^(actual_value-presence.upper_border));
  local probability = math.abs(first_part + second_part - 1);
  probability = presence.probability_offset + (presence.probability_multiplier * probability);
  return probability;
end

function mymonths.clouds_presence_chance(pos, presence_def, basic_chance_rewrite)
  local basic_chance = presence_def.basic_chance;
  if (basic_chance_rewrite~=0.0) then
    basic_chance = basic_chance_rewrite;
  end
  if (basic_chance==0.0) then
    return 0.0;
  end
  local presence_chance = 1.0;
  
  -- apply normalized time of year (1-end of January, 12-end of year)
  if (presence_def.year_time_presence~=nil) then
    minetest.log("warning", "year_time_presence "..dump(presence_def.year_time_presence));
    local year_time = mymonths.normalized_year_time();
    presence_chance = presence_chance * mymonth.probability_function(presence_def.year_time_presence, year_time);
  end

  -- final chance
  presence_chance = presence_chance * basic_chance;
  
  return presence_chance;
end

function mymonths.wind_presence_chance(pos, presence_def, basic_chance_rewrite)
  local basic_chance = presence_def.basic_chance;
  if (basic_chance_rewrite~=0.0) then
    basic_chance = basic_chance_rewrite;
  end
  if (basic_chance==0.0) then
    return 0.0;
  end
  local presence_chance = 1.0;
  
  -- apply normalized time of year (1-end of January, 12-end of year)
  if (presence_def.year_time_presence~=nil) then
    minetest.log("warning", "year_time_presence "..dump(presence_def.year_time_presence));
    local year_time = mymonths.normalized_year_time();
    presence_chance = presence_chance * mymonth.probability_function(presence_def.year_time_presence, year_time);
  end
  
  -- day time
  if (presence_def.day_time_presence~=nil) then
    minetest.log("warning", "day_time_presence "..dump(presence_def.day_time_presence));
    local day_time = minetest.get_timeofday();
    presence_chance = presence_chance * mymonth.probability_function(presence_def.day_time_presence, day_time);
  end
  
  -- final chance
  presence_chance = presence_chance * basic_chance;
  
  return presence_chance;
end

function mymonths.weather_presence_chance(pos, presence_def, basic_chance_rewrite, clouds_and_wind)
  local basic_chance = presence_def.basic_chance;
  if (basic_chance_rewrite~=0.0) then
    basic_chance = basic_chance_rewrite;
  end
  if (basic_chance==0.0) then
    return 0.0;
  end
  local presence_chance = 1.0;
  
  -- apply normalized time of year (1-end of January, 12-end of year)
  if (presence_def.year_time_presence~=nil) then
    minetest.log("warning", "year_time_presence "..dump(presence_def.year_time_presence));
    local year_time = mymonths.normalized_year_time();
    presence_chance = presence_chance * mymonth.probability_function(presence_def.year_time_presence, year_time);
  end
  
  -- day time
  if (presence_def.day_time_presence~=nil) then
    minetest.log("warning", "day_time_presence "..dump(presence_def.day_time_presence));
    local day_time = minetest.get_timeofday();
    presence_chance = presence_chance * mymonth.probability_function(presence_def.day_time_presence, day_time);
  end
  
  -- clouds density
  if (presence_def.clouds_density_presence~=nil) then
    minetest.log("warning", "clouds_density_presence "..dump(presence_def.clouds_density_presence));
    presence_chance = presence_chance * mymonth.probability_function(presence_def.clouds_density_presence, clouds_and_wind.clouds_density);
  end
      
  -- clouds gray
  if (presence_def.clouds_gray_presence~=nil) then
    minetest.log("warning", "clouds_gray_presence "..dump(presence_def.clouds_gray_presence));
    local clouds_gray =   0.2126 * clouds_and_wind.clouds.color.r 
                        + 0.7152 * clouds_and_wind.clouds.color.g
                        + 0.0722 * clouds_and_wind.clouds.color.b;
    presence_chance = presence_chance * mymonth.probability_function(presence_def.clouds_gray_presence, clouds_gray);
  end
  
  -- clouds height
  if (presence_def.clouds_height_presence~=nil) then
    minetest.log("warning", "clouds_height_presence "..dump(presence_def.clouds_height_presence));
    presence_chance = presence_chance * mymonth.probability_function(presence_def.clouds_height_presence, clouds_and_wind.clouds_height);
  end
  
  -- clouds thickness
  if (presence_def.clouds_thickness_presence~=nil) then
    minetest.log("warning", "clouds_thickness_presence "..dump(presence_def.clouds_thickness_presence));
    presence_chance = presence_chance * mymonth.probability_function(presence_def.clouds_thickness_presence, clouds_and_wind.clouds_thickness);
  end
  
  -- wind speed
  if (presence_def.wind_speed_presence~=nil) then
    minetest.log("warning", "wind_speed_presence "..dump(presence_def.wind_speed_presence));
    presence_chance = presence_chance * mymonth.probability_function(presence_def.wind_speed_presence, clouds_and_wind.wind_speed);
  end
  
  -- wind direction
  if (presence_def.wind_direction_presence~=nil) then
    minetest.log("warning", "wind_direction_presence "..dump(presence_def.wind_direction_presence));
    presence_chance = presence_chance * mymonth.probability_function(presence_def.wind_direction_presence, clouds_and_wind.wind_direction);
  end
  
  -- callback
  if (presence_def.callback_presence~=nil) then
    for parameter_key, parameter_presence in pairs(presence_def.callback_presence) do
      local callback_points = parameter_presence.callback(clouds_and_wind, parameter_presence.parameters);
      presence_chance = presence_chance * vegetation.probability_function(parameter_presence, callback_points);
    end
  end
  
  presence_chance = presence_chance * basic_chance;
  
  return presence_chance;
end

