
local timer = 0

local timechange = 0
local gm = 0
local gn = 0
local timescale = 72
local year_days = mymonths.year_months * mymonths.month_days;
-- If exists read timescale from config and store locally to prevent outside modification
if mymonths.timescale ~= nil then
	timescale = mymonths.timescale
end	
local time_speed = timescale;

local storage = mymonths.storage;

local daynight_ratio = mymonths.weather_model.year_daynight;

local function periodicChanges(periodic_def, year_day)
  local phase = periodic_def.phase + ((year_day/year_days)*2*math.pi);
	local value = math.cos(phase);
  value = value * periodic_def.amplitude + periodic_def.offset
  return value;
end

-- Set holidays
local hol = {
	{"12", 14, "It is New Years Eve!"},
	{"1",  1,  "It is New Years Day!"},
	{"3",  12, "It is Friendship Day!"},
	{"6",  5,  "It is Minetest Day!"},
	{"4",  10, "It is Miners Day!"},
	{"8",  12, "It is Builders Day!"},
	{"10", 8,  "It is Harvest Day!"},
}

-- Set days
local days = {
	{1, 8,  "Monday"},
	{2, 9,  "Tuesday"},
	{3, 10, "Wednesday"},
	{4, 11, "Thursday"},
	{5, 12, "Friday"},
	{6, 13, "Saturday"},
	{7, 14, "Sunday"},
}

-- this stops undeclared variable errors
local t1, t2, t3, t4, t5 = 0, 0, 0, 0, 0

-- Set months
local mon = {
	{1,  "January",  t5, t1, .9},
	{2,  "February", t5, t1, .9},
	{3,  "March",    t4, t2, 1},
	{4,  "April",    t4, t2, 1},
	{5,  "May",      t3, t3, 1},
	{6,  "June",     t3, t3, 1.1},
	{7,  "July",     t1, t5, 1.2},
	{8,  "August",   t1, t5, 1.5},
	{9,  "September",t3, t3, 1},
	{10, "October",  t3, t3, 1},
	{11, "November", t4, t2, .9},
	{12, "December", t4, t2, .9},
}
local months = {
  {
    name = "January",
  },
  {
    name = "February",
  },
  {
    name = "March",
  },
  {
    name = "April",
  },
  {
    name = "May",
  },
  {
    name = "June",
  },
  {
    name = "July",
  },
  {
    name = "August",
  },
  {
    name = "September",
  },
  {
    name = "October",
  },
  {
    name = "November",
  },
  {
    name = "December",
  },
}

mymonths.day_counter = 1;
mymonths.month_counter = mymonths.start_in_month;

-- added by SFENCE
-- load data from storage
if (storage:contains("timer")==true) then
  timer = storage:get_int("timer");
  storage:set_string("timer", "");
end
if (storage:contains("day_counter")==true) then
  mymonths.day_counter = storage:get_int("day_counter");
end
if (storage:contains("month_counter")==true) then
  mymonths.month_counter = storage:get_int("month_counter");
end
if (storage:contains("gm")==true) then
  gm = storage:get_int("gm");
end
if (storage:contains("gn")==true) then
  gn = storage:get_int("gn");
end
if (storage:contains("time_speed")==true) then
  time_speed = storage:get_int("time_speed");
end

minetest.setting_set("time_speed", time_speed)

-- Sets Month and length of day

minetest.register_globalstep(function(dtime)

	-- Checks every X seconds
	timer = timer + dtime

	--do not change because it will effect other values
	if timer < 3 then
		return
	end

	timer = 0

--Day Night Speeds (Thanks to sofar for this)
	local dc = tonumber(mymonths.day_counter)
	local mc = tonumber(mymonths.month_counter)
	local x = ((mc-1)*mymonths.month_days)+dc
	local ratio = ((math.cos((x / year_days) * 2 * math.pi) * 0.8) / 2.0) + 0.5
	local nightratio = math.floor(timescale * (ratio + 0.5))
	local dayratio =  math.floor(timescale / (ratio + 0.5))

	--Checks for morning
  --because of diferent night and day speed, this value is not precis
	local time_in_hours = minetest.get_timeofday() * 24

	if      (time_in_hours > 12)
	    and (timechange == 0) then

		timechange = 1
		gm = 1
	end

	if      (time_in_hours <= 12)
	    and (timechange == 1) then

		timechange = 0
		mymonths.day_counter = mymonths.day_counter + 1
	end

	if mymonths.day_counter > mymonths.month_days then
		mymonths.month_counter = mymonths.month_counter + 1
		mymonths.day_counter = 1
	end

	if tonumber(mymonths.month_counter) == nil then
		mymonths.month_counter = mymonths.start_in_month

	elseif tonumber(mymonths.month_counter) > mymonths.year_months then
		mymonths.month_counter = 1
		mymonths.day_counter = 1
	end

	-- Sets time speed in the morning
	if      (time_in_hours >= 6)
      and (time_in_hours <= 12)
	    and (gm == 1) then
		minetest.setting_set("time_speed", dayratio)
    time_speed = dayratio;
    
    if (mymonths.chat_date==true) then
		  minetest.chat_send_all("Good Morning! It is "..mymonths.day_name.." "..mymonths.month.." "..mymonths.day_counter)
    end
		--minetest.chat_send_all("Time speed is "..dayratio.." and "..nightratio)

		---Holidays
    if (mymonths.chat_holidays==true) then
      for i in ipairs(hol) do

        local h1 = hol[i][1]
        local h2 = hol[i][2]
        local h3 = hol[i][3]

        if      (mymonths.month_counter == h1)
            and (mymonths.day_counter == h2) then
          minetest.chat_send_all(h3)
        end
      end
    end

		gm = 0
		gn = 1
	end

	--Months
  if (mymonths.chat_date==true) then
    for i in ipairs(mon) do

      local m1 = mon[i][1]
      local m2 = mon[i][2]
      local m3 = mon[i][3]
      local m4 = mon[i][4]
      local m5 = mon[i][5]

      if mymonths.month_counter == m1 then

        mymonths.month = m2
        -- looks like is not used 
        --mymonths.day_speed = m3
        --mymonths.night_speed = m4
      end
    end
  end

	if      (time_in_hours >= 22)
	    and (time_in_hours <= 24)
	    and (gn == 1) then

		minetest.setting_set("time_speed", nightratio)
    time_speed = nightratio;

		gn = 0
	end

	-- Set the name of the day
  if (mymonths.chat_date==true) then
    for i in ipairs(days) do

      local w1 = days[i][1]
      local w2 = days[i][2]
      local dy = days[i][3]

      if      (mymonths.day_counter == w1)
          or  (mymonths.day_counter == w2) then

        mymonths.day_name = dy
      end
    end
  end
  
  storage:set_int("day_counter", mymonths.day_counter);
  storage:set_int("month_counter", mymonths.month_counter);
  storage:set_int("gm", gm);
  storage:set_int("gn", gn);
  storage:set_int("time_speed", time_speed);
end)

minetest.register_on_shutdown( function()
    storage:set_int("timer", timer);
  end);


