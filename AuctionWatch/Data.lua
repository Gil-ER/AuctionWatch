--aw namespace variable
local _, aw = ...;

--Sound constants
--aw.Sound.RaidWarning = 8959;

function AuctionWatchGetAuctions()
	if aw.auctionCount == nil then 
		return 0;
	else
		return aw.auctionCount;
	end
end

local isKeyValid = function (key)
	--Returns true if aWatchDB["Settings"][key] exists in the database
	aw:VerifyDatabase()	--check if existing and add with default values if not
	if aWatchDB.Settings[key] == nil then return false; else return true; end;
end

--*************************************************************************************
--	Get settings from DB
--*************************************************************************************
function aw:GetChat() 			if isKeyValid("Chat") then return aWatchDB.Settings.Chat; end; end;
function aw:GetWindow() 		if isKeyValid("Window") then return aWatchDB.Settings.Window; end; end;
function aw:GetOnlyOver() 		if isKeyValid("OnlyOver") then return aWatchDB.Settings.OnlyOver; end; end; 
function aw:GetDays() 	 		if isKeyValid("Days") then return aWatchDB.Settings.Days; end; end;
function aw:GetAsc()      		if isKeyValid("Asc") then return aWatchDB.Settings.Asc; end; end;
function aw:GetByDate()   	 	if isKeyValid("ByDate") then return aWatchDB.Settings.ByDate; end; end;
function aw:GetWindowOnlyOver()	if isKeyValid("WinOnlyOver") then return aWatchDB.Settings.WinOnlyOver; end; end;
function aw:GetSoundFlag()      if isKeyValid("PlaySound") then return aWatchDB.Settings.PlaySound; end; end;
--*************************************************************************************
--	Update settings
--*************************************************************************************
function aw:SetChat(value)				if isKeyValid("Chat") then aWatchDB.Settings.Chat = value; end; end;
function aw:SetWindow(value)			if isKeyValid("Window") then aWatchDB.Settings.Window = value; end; end;
function aw:SetOnlyOver(value)			if isKeyValid("OnlyOver") then aWatchDB.Settings.OnlyOver = value; end; end;
function aw:SetDays(value)				if isKeyValid("Days") then aWatchDB.Settings.Days = value; end; end;
function aw:SetAsc(value)				if isKeyValid("Asc") then aWatchDB.Settings.Asc = value; end; end;
function aw:SetByDate(value)			if isKeyValid("ByDate") then aWatchDB.Settings.ByDate = value; end; end;
function aw:SetWindowOnlyOver(value)	if isKeyValid("WinOnlyOver") then aWatchDB.Settings.WinOnlyOver = value; end; end;
function aw:SetSoundFlag(value)	 		if isKeyValid("PlaySound") then aWatchDB.Settings.PlaySound = value; end; end;

function aw:RemoveToonFromDB(t)
	if aWatchDB["Auctions"] ~= nil then --delete this toon if there is no current auctions
		if aWatchDB["Auctions"][t] ~= nil then aWatchDB["Auctions"][t] = nil; end;
	end;
end

function aw:UpdateToon(t)
	if aWatchDB["Auctions"] == nil then aWatchDB["Auctions"] = {}; end;	--create table if empty
	aWatchDB["Auctions"][t] = { ["count"] = aw.auctionCount; ["time"] = time() };
end

function aw:VerifyDatabase()
	--check if DB exists  and create if not
	if aWatchDB == nil then aWatchDB = {}; end;		
	if aWatchDB["Settings"] == nil then	aw:DefaultSettings(); end;
end

function aw:GetCount(t)
	if t == nil then t = aw.ID; end;
	--returns the number of auctions that toon 't' has listed (according to the database)
	if aWatchDB["Auctions"] ~= nil then
		if aWatchDB["Auctions"][t] ~= nil then 
			if aWatchDB["Auctions"][t]["count"] ~= nil then 
				return aWatchDB["Auctions"][t]["count"]; 
			end
		end
	end	
	return 0;	--something was nil so return 0

	
end

function aw:DefaultSettings()
	aWatchDB["Settings"] = { 	
		["Chat"] = false; 			--Don't list to chat
		["OnlyOver"] = true; 		--Only list with expired auctions
		["Window"] = true; 			--List to window(aw.Output frame)
		["WinOnlyOver"] = true;		--Only show the frame if there are expired auctions
		["Days"] = 2; 				--2 days from last AH visit before auctions are considered expired
		["Asc"] = false; 			--Sort in descending order
		["ByDate"] = true; 			--Sort by date
		["PlaySound"] = true }; 	--Play Raid Warning when you have auctiond more then 25 days old
end

