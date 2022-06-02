--aw namespace variable
local addon, aw = ...;

local t = {};		--table of FontStrings placed on the frame
local list = {};	--table of strings to display
aw.button = {};		--array of buttons created at the bottom of the output frame
local currentIndex = 1;

function aw:colorString(c, str)
	local color = 	{ ["red"] = "FF0000", ["green"]  = "00FF00" }
	if str == nil then str = "nil"; end;
	return string.format("|cff%s%s|r", color[c], str);
end

function aw:myPrint( ... )
    local prefix = string.format("|cff%s%s|r", "0088EE", "Auction Watch: ");	
	local message = string.join(" ", ...);
	print(prefix,  message);
end

--Create strings and position for form info
local CreateStringTable = function ()
	for i = 1, 20 do
		local row = -15 + (-15 * i);		--row spacing
		t[i] = {	[1] = aw.Output:CreateFontString("awText_" .. i .."1", "OVERLAY", "GameFontNormal"), 
					[2] = aw.Output:CreateFontString(nil, "OVERLAY", "GameFontNormal"),
					[3] = aw.Output:CreateFontString(nil, "OVERLAY", "GameFontNormal"),
					[4] = aw.Output:CreateFontString(nil, "OVERLAY", "GameFontNormal"),
					[5] = aw.Output:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			};
		t[i][1]:SetPoint("TOPLEFT", 15, row);
		t[i][1]:SetWidth(35);
		t[i][1]:SetJustifyH("RIGHT");
		
		t[i][2]:SetPoint("TOPLEFT", t[i][1], "TOPRIGHT", 10, 0);	
		t[i][2]:SetWidth(190);
		t[i][2]:SetJustifyH("LEFT");
		
		t[i][3]:SetPoint("TOPLEFT", t[i][2], "TOPRIGHT", 0, 0);
		t[i][3]:SetWidth(55);
		t[i][3]:SetJustifyH("LEFT");
		
		t[i][4]:SetPoint("TOPLEFT", t[i][3], "TOPRIGHT", 0, 0);
		t[i][4]:SetWidth(30);
		t[i][4]:SetJustifyH("RIGHT");		

		t[i][5]:SetPoint("TOPLEFT", t[i][4], "TOPRIGHT", 0, 0);
		t[i][5]:SetWidth(40);
		t[i][5]:SetJustifyH("LEFT");		
	end;
	t[21] = { [1] = aw.Output:CreateFontString(nil, "OVERLAY", "GameFontNormal") };
	t[21][1]:SetPoint("TOPLEFT", 15, -15 * 23);
	t[21][1]:SetText("/aw or /auctionwatch to show this report.");
end 

function aw:ClearAllText()
	for i = 1, 20 do		--20 lines
		for j = 1, 5 do		--5 positions
			t[i][j]:SetText("");
		end
	end
end

aw.auctions = {};
function aw.auctions:Clear()
	list = {};
end

function aw.auctions:AddLine(col1, col2, col3, col4, col5)
	local idx = #list + 1
	list[idx] = { [1] = col1; [2] = col2; [3] = col3; [4] = col4; [5] = col5 };	
end

function aw.auctions:Show(idx)
	if idx == nil then idx = 1; end;
	if aw.slider == nil then print("nil"); return; end;
	aw:ClearAllText();
	aw.slider:SetMinMaxValues(1, #list);
	aw.slider:SetValue(idx);
	if #list < 1 then return; end;
	if idx > #list then idx = #list; end;
	for row = 0, 19 do
		t[row + 1][1]:SetText(list[idx + row][1]);
		t[row + 1][2]:SetText(list[idx + row][2]);
		t[row + 1][3]:SetText(list[idx + row][3]);
		t[row + 1][4]:SetText(list[idx + row][4] .. ":");
		t[row + 1][5]:SetText(list[idx + row][5]);
		if idx + row == #list then return; end;
	end
end

function aw:GetListedToon(idx)
	return t[idx][2]:GetText()
end

--**************************************************************************
-- Output frame
--**************************************************************************
local params = {
	title = "Last visit to the auction house",
	anchor = "CENTER",
	parent = UIParent,
	relFrame = UIParent,
	relPoint = "CENTER",
	xOff = 0,
	yOff = 0,
	width = 375,
	height = 400,
	isMovable = true
}
aw.Output = aw:createFrame(params);			--Create the Frame
CreateStringTable();						--Create a string grid to display the output 
--Add the buttons and handlers
local w = (params.width -20) / 3;
params = {
	anchor = "BOTTOMRIGHT",
	parent = aw.Output,
	relFrame = aw.Output,
	relPoint = "BOTTOMRIGHT",
	xOff = -10,
	yOff = 10,
	width = w,
	height = 30,
	caption	= "Swap Sort",
	ttip = "Swap the field being sorted\nNumber of auctions/time since last visit.",
	pressFunc = function (self) aw:ReportAuctionsToWindow(true); end;
}
aw:createButton(params);
params = {
	anchor = "BOTTOMRIGHT",
	parent = aw.Output,
	relFrame = aw.Output,
	relPoint = "BOTTOMRIGHT",
	xOff = -10 - w,
	yOff = 10,
	width = w,
	height = 30,
	caption	= "Remove Toon",
	ttip = "Swap the field being sorted\nNumber of auctions/time since last visit.",
	pressFunc = function (self) aw:RemoveToon(); end;
}
aw:createButton(params);
params = {
	anchor = "BOTTOMRIGHT",
	parent = aw.Output,
	relFrame = aw.Output,
	relPoint = "BOTTOMRIGHT",
	xOff = -10 - (2 * w),
	yOff = 10,
	width = w,
	height = 30,
	caption	= "Open Config.",
	ttip = "Swap the field being sorted\nNumber of auctions/time since last visit.",
	pressFunc = function (self) InterfaceOptionsFrame_OpenToCategory(aw.panel);
								InterfaceOptionsFrame_OpenToCategory(aw.panel); end;
}
aw:createButton(params);
params = {
	name = nil,				--globally unique, only change if you need it
	parent = aw.Output,			--parent frame
	relFrame = aw.Output,		--relative control for positioning
	anchor = "TOPRIGHT", 		--anchor point of this form
	relPoint = "TOPRIGHT",		--relative point for positioning	
	xOff = -5,					--x offset from relative point
	yOff = -25,					--y offset from relative point
	width = 10,					--frame width
	height = 310,				--frame height
	orientation = "VERTICAL",	--VERTICAL (side)
	min = "",
	max = "",
	step = 1
}
aw.slider = aw:createSlider(params);
aw.slider:SetScript( "OnValueChanged", function ()
	local i = tonumber( format( "%.0f", aw.slider:GetValue() ) );	--convert to integer
	--Only update the list if the number changed
	if i ~= currentIndex then			
		currentIndex = i;
		aw.auctions:Show(i);
	end;
end);
aw.Output:SetScript( "OnMouseWheel", function (self, direction)
	local pos = tonumber( format( "%.0f", aw.slider:GetValue() ) );	--convert to integer
	local sMin, sMax = aw.slider:GetMinMaxValues();
	if pos == sMax or pos == sMax then return; end;
	if direction == 1 then aw.slider:SetValue( pos - 1 ); end;	
	if direction == -1 then aw.slider:SetValue( pos + 1 ); end;
end);

--aw.Output:SetScript("OnEscapePressed", function(self) aw.Output:Hide(); end); --looking for a control with event
aw.Output:Hide();

