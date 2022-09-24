--aw namespace variable
local _, aw = ...;

function AuctionWatchGetAuctions()
	--Global function that returns the number of active auctions
	return aw.auctionCount;
end;

local defaultSettings = { 	
	["Chat"] = false; 			--Don't list to chat
	["OnlyOver"] = true; 		--Only list with expired auctions
	["Window"] = true; 			--List to window(aw.Output frame)
	["WinOnlyOver"] = true;		--Only show the frame if there are expired auctions
	["Days"] = 2; 				--2 days from last AH visit before auctions are considered expired
	["Asc"] = false; 			--Sort in descending order
	["ByDate"] = true; 			--Sort by date
	["PlaySound"] = true }; 	--Play Raid Warning when you have auctiond more then 25 days old

local dbSettingsValid = false;
--*************************************************************************************
--	Get settings from DB
--*************************************************************************************
function aw:GetSetting(key)
	if dbSettingsValid == false then
		aWatchDB = aWatchDB or {};
		aWatchDB.Settings = aWatchDB.Settings or {};
		dbSettingsValid = true;
	end;
	if aWatchDB.Settings[key] == nil then aWatchDB.Settings[key] = defaultSettings[key]; end;
	return aWatchDB.Settings[key];
end;

--*************************************************************************************
--	Update settings
--*************************************************************************************
function aw:dbSaveSetting(key, value)
	if dbSettingsValid == false then
		--check if DB exists  and create if not
		aWatchDB = aWatchDB or {};
		aWatchDB.Settings = aWatchDB.Settings or {};
		dbSettingsValid = true;
	end;
	aWatchDB.Settings[key]= value;
end; 

function aw:RemoveToonFromDB(t)
	if aWatchDB.Auctions ~= nil then --delete this toon if there is no current auctions
		if aWatchDB.Auctions[t] ~= nil then aWatchDB.Auctions[t] = nil; end;
	end;
end;

function aw:UpdateToon(t)
	aWatchDB.Auctions = aWatchDB.Auctions or {};
	aWatchDB.Auctions[t] = { ["count"] = aw.auctionCount; ["time"] = time() };
end;

function aw:GetCount(t)
	if t == nil then t = aw.ID; end;
	--returns the number of auctions that toon 't' has listed (according to the database)
	if aWatchDB.Auctions ~= nil then
		if aWatchDB.Auctions[t] ~= nil then 
			if aWatchDB.Auctions[t]["count"] ~= nil then 
				return aWatchDB.Auctions[t]["count"]; 
			end
		end
	end	
	return 0;	--something was nil so return 0	
end;

function aw:SetDefaults()
	for key, value in pairs(defaultSettings) do
		aw:dbSaveSetting(key, value);
	end;
end;
