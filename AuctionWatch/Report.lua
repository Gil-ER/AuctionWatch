-- Edited Mar 16, 2023

local _, aw = ...;
local currentSort;
local TimePassed = function (t)
	local timespan = (time() - t);
	local days = 0;
	local hours = 0;
	local mins = 0;
	local d = 24*60*60		
	local h = 60*60			
	local m = 60			
	while timespan > d do		
		days = days + 1;
		timespan = timespan - d;
	end;
	while timespan > h do		
		hours = hours + 1;
		timespan = timespan - h;
	end;
	while timespan > m do		
		mins = mins + 1;
		timespan = timespan - m;
	end;
	if mins < 10 then mins = "0" .. mins; end;
	if mins == "0" then mins = "00"; end;
	return days, hours, mins;
end
function aw:ExpiredAuctions()
	local t = time() - ( aw:GetSetting("Days") * 24 * 60 * 60 ) 
	if aWatchDB["Auctions"] ~= nil then
		for cName, cTable in pairs(aWatchDB["Auctions"]) do
			if cTable["time"]  < t then 
				return true;
			end;
		end;
	end;
	return false;
end
function aw:VeryOldAuctions()
	local t = time() - ( 25 * 24 * 60 * 60 ) 
	if aWatchDB.Auctions ~= nil then
		for cName, cTable in pairs(aWatchDB.Auctions) do
			if cTable.time < t then 
				return true;
			end;
		end;
	end;
	return false;
end;
function aw:ReportAuctionsToChat()
	local auc = {};
	local i = 1;
	local t = time() - (aw:GetSetting("Days") * 24 * 60 * 60)				
	if aWatchDB["Auctions"] ~= nil then								
		for cName, cTable in pairs(aWatchDB["Auctions"]) do
			if aw:GetSetting("OnlyOver") then 			
				if cTable["time"] < t then
					auc[#auc + 1] = {["name"] = cName; ["count"] = cTable["count"]; ["time"] = cTable["time"] };
				end;
			else
				auc[#auc + 1] = {["name"] = cName; ["count"] = cTable["count"]; ["time"] = cTable["time"] };
			end;
		end;
	end;		
	if aw:GetSetting("ByDate") then
		if aw:GetSetting("Asc") then		
			table.sort (auc, function(a,b) return a.time < b.time; end);
		else
			table.sort (auc, function(a,b) return a.time > b.time; end);
		end;	
	else
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
	local byDate = aw:GetSetting("ByDate");
	if flag == nil then currentSort = byDate; end;
	if flag == true then currentSort = not currentSort; byDate = currentSort; end;
	local auc = {};
	local i = 1;
	local t = time() - (aw:GetSetting("Days") * 24 * 60 * 60)	
	if aWatchDB and aWatchDB.Auctions then								
		for cName, cTable in pairs(aWatchDB["Auctions"]) do
			auc[#auc + 1] = {["name"] = cName; ["count"] = cTable["count"]; ["time"] = cTable["time"] }
		end;
	end;	
	if byDate then
		if aw:GetSetting("Asc") then
			table.sort (auc, function(a,b) return a.time > b.time; end);
		else
			table.sort (auc, function(a,b) return a.time < b.time; end);
		end;	
	else	
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
