--aw namespace variable
local _, aw = ...;

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

local ButtonFactory = function (text, ttip)
	--text: caption for the button
	--creates a new button and places it in an array then sizes and positions it 
	local bCount = #aw.button + 1;
	aw.button[bCount] = CreateFrame("Button", "AwButton" .. bCount, aw.Output)
	local b = aw.button[bCount];
	if bCount == 1 then
		b:SetPoint("BOTTOMRIGHT", aw.Output, "BOTTOMRIGHT",-5, 5)
	else
		b:SetPoint("BOTTOMRIGHT", aw.button[bCount - 1], "BOTTOMLEFT", 0, 0)
	end
	b:SetWidth((aw.Output:GetWidth() - 5 ) / 3);
	b:SetHeight(25);        
	b:SetNormalFontObject("GameFontNormal")
	b:SetText(text);
	
	local ntex = b:CreateTexture()
	ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()	
	b:SetNormalTexture(ntex)
	
	local htex = b:CreateTexture()
	htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	b:SetHighlightTexture(htex)
	
	local ptex = b:CreateTexture()
	ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	ptex:SetAllPoints()
	b:SetPushedTexture(ptex)
	
	b:SetScript("OnEnter", function (self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP");
		GameTooltip:AddLine(ttip)
		GameTooltip:Show();
	end);
	b:SetScript("OnLeave", function(self) GameTooltip:Hide(); end);
	
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
	aw:ClearAllText();
	aw.OutputSlider:SetMinMaxValues(1, #list);
	aw.OutputSlider:SetValue(idx);
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
--[[
function aw:SetRow(row, col1, col2, col3, col4, col5)
	if col1 == nil then col1 = ""; end;
	if col2 == nil then col2 = ""; end;
	if col3 == nil then col3 = ""; end;
	if col4 == nil then col4 = ""; end;
	if col5 == nil then col5 = ""; end;
	if row > 0 and row < 21 then
		t[row][1]:SetText(col1);
		t[row][2]:SetText(col2);
		t[row][3]:SetText(col3);
		t[row][4]:SetText(col4 .. ":");
		t[row][5]:SetText(col5);
	end
end
]]
function aw:GetListedToon(idx)
	return t[idx][2]:GetText()
end

--**************************************************************************
-- Output frame
--**************************************************************************
--Create Frame
aw.Output = CreateFrame("Frame", "awOutputFrame", UIParent, "BasicFrameTemplate");
aw.Output:SetPoint("CENTER",UIParent);
--Make dragable
aw.Output:EnableMouse(true);
aw.Output:SetMovable(true);
aw.Output:SetUserPlaced(true); 
aw.Output:RegisterForDrag("LeftButton");
aw.Output:SetScript("OnDragStart", function(self) self:StartMoving() end);
aw.Output:SetScript("OnDragStart", function(self) self:StartMoving() end);
aw.Output:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); end);
--Size (width, height)
aw.Output:SetSize(375, 390);
aw.Output:SetPoint("TOPLEFT");
--Add the title
aw.Output.Title = aw.Output:CreateFontString(nil, "OVERLAY", "GameFontNormal");
aw.Output.Title:SetPoint("TOPLEFT",15,-5);
aw.Output.Title:SetWidth(330);
aw.Output.Title:SetJustifyH("CENTER");
aw.Output.Title:SetText( "Last visit to the auction house" );
CreateStringTable();
--Add the buttons and handlers
ButtonFactory("Swap Sort", "Swap the field being sorted\nNumber of auctions/time since last visit.");
ButtonFactory("Remove Toon", "Remove a toon from the list. \n\nPerhaps you picked up mail but\ndidn't visit the auction house\nand the toon is still listed.");
ButtonFactory("Open Config.", "Open configuration options.");
aw.button[1]:SetScript("OnClick", function(self) aw:ReportAuctionsToWindow(true); end);
aw.button[2]:SetScript("OnClick", function(self) aw:RemoveToon(); end);
aw.button[3]:SetScript("OnClick", function(self) InterfaceOptionsFrame_OpenToCategory(aw.panel);
			InterfaceOptionsFrame_OpenToCategory(aw.panel); end);
--Add a slider to scroll the report if you have more than 20 toons with auctions	
aw.OutputSlider = CreateFrame("Slider", "AW_Output_Slider", aw.Output, "OptionsSliderTemplate");
aw.OutputSlider:SetOrientation("VERTICAL");
aw.OutputSlider:SetPoint ("TOPRIGHT", aw.Output, "TOPRIGHT", -5, -25); 
aw.OutputSlider:SetWidth(10);
aw.OutputSlider:SetHeight(310); 
getglobal(aw.OutputSlider:GetName() .. "Low"):SetText("");
getglobal(aw.OutputSlider:GetName() .. "High"):SetText("");
aw.OutputSlider:SetScript( "OnValueChanged", function (self)
	local i = tonumber( format( "%.0f", aw.OutputSlider:GetValue() ) );	--convert to integer
	--Only update the list if the number changed
	if i ~= currentIndex then			
		currentIndex = i
		aw.auctions:Show(i);
	end
end);
aw.Output:SetScript( "OnMouseWheel", function (self, dir)
	local pos = tonumber( format( "%.0f", aw.OutputSlider:GetValue() ) );	--convert to integer
	local sMin, sMax = aw.OutputSlider:GetMinMaxValues();
	if pos == sMax or pos == sMax then return; end;
	if dir == 1 then aw.OutputSlider:SetValue( pos - 1 ); end;	
	if dir == -1 then aw.OutputSlider:SetValue( pos + 1 ); end;
end);
--aw.button[1]:SetScript("OnEscapePressed", function(self) aw.Output:Hide(); end); --looking for a control with event
aw.Output:Hide();

