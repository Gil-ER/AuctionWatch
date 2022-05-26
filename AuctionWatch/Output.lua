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

-- local ButtonFactory = function (text, ttip)
	-- --text: caption for the button
	-- --creates a new button and places it in an array then sizes and positions it 
	-- local bCount = #aw.button + 1;
	-- aw.button[bCount] = CreateFrame("Button", "AwButton" .. bCount, aw.Output)
	-- local b = aw.button[bCount];
	-- if bCount == 1 then
		-- b:SetPoint("BOTTOMRIGHT", aw.Output, "BOTTOMRIGHT",-5, 5)
	-- else
		-- b:SetPoint("BOTTOMRIGHT", aw.button[bCount - 1], "BOTTOMLEFT", 0, 0)
	-- end
	-- b:SetWidth((aw.Output:GetWidth() - 5 ) / 3);
	-- b:SetHeight(25);        
	-- b:SetNormalFontObject("GameFontNormal")
	-- b:SetText(text);
	
	-- local ntex = b:CreateTexture()
	-- ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	-- ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	-- ntex:SetAllPoints()	
	-- b:SetNormalTexture(ntex)
	
	-- local htex = b:CreateTexture()
	-- htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	-- htex:SetTexCoord(0, 0.625, 0, 0.6875)
	-- htex:SetAllPoints()
	-- b:SetHighlightTexture(htex)
	
	-- local ptex = b:CreateTexture()
	-- ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	-- ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	-- ptex:SetAllPoints()
	-- b:SetPushedTexture(ptex)
	
	-- b:SetScript("OnEnter", function (self)
		-- GameTooltip:SetOwner(self, "ANCHOR_TOP");
		-- GameTooltip:AddLine(ttip)
		-- GameTooltip:Show();
	-- end);
	-- b:SetScript("OnLeave", function(self) GameTooltip:Hide(); end);
	
-- end

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
	if aw.Output.Slider == nil then print("nil"); return; end;
	aw:ClearAllText();
	aw.Output.Slider:SetMinMaxValues(1, #list);
	aw.Output.Slider:SetValue(idx);
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
--Add a slider to scroll the report if you have more than 20 toons with auctions			
			
local sliderCount = 0;
function aw:createSlider(opts)
	sliderCount = sliderCount + 1;		--Counts each button created
	if opts.name == nil or opts.name == "" then
		--Unique name generator, addonName + string + counterValue
		opts.name = addon .. "GeneratedSliderNumber" .. sliderCount;
	end
	local slide = CreateFrame("Slider", opts.name, aw.Output, "OptionsSliderTemplate");
	slide:SetOrientation(opts.orienation);
	slide:SetPoint ("TOPRIGHT", aw.Output, "TOPRIGHT", -5, -25); 
	slide:SetWidth(10);
	slide:SetHeight(310);
	getglobal(opts.name .. "Low"):SetText("");
	getglobal(opts.name .. "High"):SetText("");
	slide:SetScript( "OnValueChanged", function ()
		local i = tonumber( format( "%.0f", slide:GetValue() ) );	--convert to integer
		--Only update the list if the number changed
		if i ~= currentIndex then			
			currentIndex = i
			aw.auctions:Show(i);
		end
	end);
	opts.parent:SetScript( "OnMouseWheel", function (self, dir)
		local pos = tonumber( format( "%.0f", slide:GetValue() ) );	--convert to integer
		local sMin, sMax = slide:GetMinMaxValues();
		if pos == sMax or pos == sMax then return; end;
		if dir == 1 then slide:SetValue( pos - 1 ); end;	
		if dir == -1 then slide:SetValue( pos + 1 ); end;
	end);
	return slide;
end


params = {
	name = nil,				--globally unique, only change if you need it
	parent = aw.Output,			--parent frame
	relFrame = aw.Output,		--relative control for positioning
	anchor = "TOPRIGHT", 		--anchor point of this form
	relPoint = "TOPRIGHT",		--relative point for positioning	
	xOff = -5,					--x offset from relative point
	yOff = -25,					--y offset from relative point
	width = 350,				--frame width
	height = 400,				--frame height
	orienation = "VERTICAL",	--VERTICAL (side)
	scrollFunc = aw.auctions:Show(i);



}
aw.Output.Slider = aw:createSlider(params);

	
--aw.OutputSlider = CreateFrame("Slider", "AW_Output_Slider", aw.Output, "OptionsSliderTemplate");
--aw.OutputSlider:SetOrientation("VERTICAL");
--aw.OutputSlider:SetPoint ("TOPRIGHT", aw.Output, "TOPRIGHT", -5, -25); 
--aw.OutputSlider:SetWidth(10);
--aw.OutputSlider:SetHeight(310); 
--getglobal(aw.OutputSlider:GetName() .. "Low"):SetText("");
--getglobal(aw.OutputSlider:GetName() .. "High"):SetText("");
-- aw.OutputSlider:SetScript( "OnValueChanged", function (self)
	-- local i = tonumber( format( "%.0f", aw.OutputSlider:GetValue() ) );	--convert to integer
	-- --Only update the list if the number changed
	-- if i ~= currentIndex then			
		-- currentIndex = i
		-- aw.auctions:Show(i);
	-- end
-- end);
-- aw.Output:SetScript( "OnMouseWheel", function (self, dir)
	-- local pos = tonumber( format( "%.0f", aw.OutputSlider:GetValue() ) );	--convert to integer
	-- local sMin, sMax = aw.OutputSlider:GetMinMaxValues();
	-- if pos == sMax or pos == sMax then return; end;
	-- if dir == 1 then aw.OutputSlider:SetValue( pos - 1 ); end;	
	-- if dir == -1 then aw.OutputSlider:SetValue( pos + 1 ); end;
-- end);



--aw.button[1]:SetScript("OnEscapePressed", function(self) aw.Output:Hide(); end); --looking for a control with event
aw.Output:Hide();

