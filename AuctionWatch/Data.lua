-- Edited Mar 16, 2023

local _, aw = ...;
function AuctionWatchGetAuctions()
	return aw.auctionCount;
end;
local defaultSettings = { 	
	["Chat"] = false; 			
	["OnlyOver"] = true; 		
	["Window"] = true; 			
	["WinOnlyOver"] = true;		
	["Days"] = 2; 				
	["Asc"] = false; 			
	["ByDate"] = true; 			
	["PlaySound"] = true }; 	
local dbSettingsValid = false;
function aw:GetSetting(key)
	if dbSettingsValid == false then
		aWatchDB = aWatchDB or {};
		aWatchDB.Settings = aWatchDB.Settings or {};
		dbSettingsValid = true;
	end;
	if aWatchDB.Settings[key] == nil then aWatchDB.Settings[key] = defaultSettings[key]; end;
	return aWatchDB.Settings[key];
end;
function aw:dbSaveSetting(key, value)
	if dbSettingsValid == false then
		aWatchDB = aWatchDB or {};
		aWatchDB.Settings = aWatchDB.Settings or {};
		dbSettingsValid = true;
	end;
	aWatchDB.Settings[key]= value;
end; 
function aw:RemoveToonFromDB(t)
	if aWatchDB.Auctions ~= nil then 
		if aWatchDB.Auctions[t] ~= nil then aWatchDB.Auctions[t] = nil; end;
	end;
end;
function aw:UpdateToon(t)
	aWatchDB.Auctions = aWatchDB.Auctions or {};
	aWatchDB.Auctions[t] = { ["count"] = aw.auctionCount; ["time"] = time() };
end;
function aw:GetCount(t)
	if t == nil then t = aw.ID; end;
	if aWatchDB.Auctions ~= nil then
		if aWatchDB.Auctions[t] ~= nil then 
			if aWatchDB.Auctions[t]["count"] ~= nil then 
				return aWatchDB.Auctions[t]["count"]; 
			end
		end
	end	
	return 0;	
end;
function aw:SetDefaults()
	for key, value in pairs(defaultSettings) do
		aw:dbSaveSetting(key, value);
	end;
end;
