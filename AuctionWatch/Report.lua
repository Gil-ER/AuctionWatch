--aw namespace variable
local _, aw = ...;
local currentSort;

local TimePassed = function (t)
	local timespan = (time() - t);
	local days = 0;
	local hours = 0;
	local mins = 0;
	local d = 24*60*60		--seconds/day
	local h = 60*60			--seconds/hour
	local m = 60			--seconds/min
	
	while timespan > d do		--while timespan > 1 day
		days = days + 1;
		timespan = timespan - d;
	end;
	while timespan > h do		--while timespan > 1 hour
		hours = hours + 1;
		timespan = timespan - h;
	end;
	while timespan > m do		--while timespan > 1 min
		mins = mins + 1;
		timespan = timespan - m;
	end;
	if mins < 10 then mins = "0" .. mins; end;
	if mins == "0" then mins = "00"; end;
	return days, hours, mins;
end

function aw:ExpiredAuctions()
	--Check to see if any toons have auctions past the set number of days
	local t = time() - ( aw:GetSetting("Days") * 24 * 60 * 60 ) --current time - (seconds in set number of days)
	if aWatchDB["Auctions"] ~= nil then
		for cName, cTable in pairs(aWatchDB["Auctions"]) do
			if cTable["time"]  < t then 
				--Older than x days return true
				return true;
			end;
		end;
	end;
	return false;
end

function aw:VeryOldAuctions()
	--checkes if any toon has auctions older than 25 days
	--returns true or false
	local t = time() - ( 25 * 24 * 60 * 60 ) --current time - (seconds in 25 days)
	if aWatchDB.Auctions ~= nil then
		for cName, cTable in pairs(aWatchDB.Auctions) do
			if cTable.time < t then 
				--Older than x days return true
				return true;
			end;
		end;
	end;
	return false;
end;

function aw:ReportAuctionsToChat()
	--List a report to chat of toons with auctions
	local auc = {};
	local i = 1;
	local t = time() - (aw:GetSetting("Days") * 24 * 60 * 60)				--days to seconds before current time
	if aWatchDB["Auctions"] ~= nil then								--read all auction data into a local table
		for cName, cTable in pairs(aWatchDB["Auctions"]) do
			if aw:GetSetting("OnlyOver") then 			--if flag is set only get older records
				if cTable["time"] < t then
					auc[#auc + 1] = {["name"] = cName; ["count"] = cTable["count"]; ["time"] = cTable["time"] };
				end;
			else
				auc[#auc + 1] = {["name"] = cName; ["count"] = cTable["count"]; ["time"] = cTable["time"] };
			end;
		end;
	end;		
	--Print to chat 
	if aw:GetSetting("ByDate") then
		--Sort by date
		if aw:GetSetting("Asc") then		
			table.sort (auc, function(a,b) return a.time < b.time; end);
		else
			table.sort (auc, function(a,b) return a.time > b.time; end);
		end;	
	else
		--Sort by number of auctions
		if aw:GetSetting("Asc") then		
			table.sort (auc, function(a,b) return a.count < b.count; end);
		else
			table.sort (auc, function(a,b) return a.count > b.count; end);
		end;	
	end;
	
	for k, v in pairs(auc) do
		local d, h, m = TimePassed(v.time)
		local dt = h .. ":" .. m;
		if d > 0 then if d == 1 then dt = d .. " day " .. dt; else dt = d .. " days " .. dt; end; end;
		if aw:GetSetting("ByDate") then
			print(dt, " ", v.name, " ", v.count);			
		else
			print(v.count, " ", v.name, " ", dt);		
		end
	end
end

function aw:GetAuctions( flag )
	--List a report to window of toons with auctions
	local byDate = aw:GetSetting("ByDate");
	if flag == nil then currentSort = byDate; end;
	if flag == true then currentSort = not currentSort; byDate = currentSort; end;
	local auc = {};
	local i = 1;
	local t = time() - (aw:GetSetting("Days") * 24 * 60 * 60)	--days to seconds before current time
	if aWatchDB and aWatchDB.Auctions then								--read all auction data into a local table
		for cName, cTable in pairs(aWatchDB["Auctions"]) do
			auc[#auc + 1] = {["name"] = cName; ["count"] = cTable["count"]; ["time"] = cTable["time"] }
		end;
	end;	
	if byDate then
		--By date
		if aw:GetSetting("Asc") then
			table.sort (auc, function(a,b) return a.time > b.time; end);
		else
			table.sort (auc, function(a,b) return a.time < b.time; end);
		end;	
	else	
		--By number of auctions
		if aw:GetSetting("Asc") then
			table.sort (auc, function(a,b) return a.count < b.count; end);
		else
			table.sort (auc, function(a,b) return a.count > b.count; end);
		end	
	end
	local c, n, d, h, m = "", "", "", "", "";
	for k, v in pairs(auc) do
		local days, hours, mins = TimePassed(v.time);
		local dStr = "";		
		if days > 0 then if days == 1 then dStr = days .. " day"; else dStr = days .. " days"; end; end;		
		c = c .. v.count .. "\n";
		n = n .. v.name .. "\n";
		d = d .. dStr .. "\n";
		h = h .. hours .. ":\n";
		m = m .. mins .. "\n";
	end;
	return c, n, d, h, m;
end