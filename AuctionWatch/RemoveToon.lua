--aw namespace variable
local _, aw = ...;

local menuList = {};

local ConfirmDelete = function(toon)	
	StaticPopupDialogs["AW_CONFIRM_DELETE"] = {
		text = "Do you really want to remove\n" .. toon .. "\nfrom this list?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			aw:RemoveToonFromDB(toon);
			aw.OutputList:Hide();
			aw.OutputList:Show();
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true
	}	
	StaticPopup_Show ("AW_CONFIRM_DELETE");
end

local AddItem = function(text, func)
    local info = {["text"] = text; ["func"] = func};	
    table.insert(menuList, info)
end

local l = CreateFrame("Frame", "RemoveToonFrame", UIParent, "UIDropDownMenuTemplate");
function aw:RemoveToon(tb)	
    menuList = {};		--Clear old data.	
	local toons = aw:GetListedToon(tb);
	for i = 1, #toons do
		local t = toons[i];
		if t ~= nil and t > "" then AddItem(t, function() ConfirmDelete(t); end); end;
	end;
	AddItem('Close', function() end);	
	EasyMenu(menuList, l, "cursor", 0, 0, "MENU")	
end


