--aw namespace variable
local addon, aw = ...;

--**************************************************************************
-- Output frame
--**************************************************************************
local params = {
	title = "Last visit to the auction house",
	name = "AuctionWatchReportFrameNew",
	anchor = "TOPLEFT",
	parent = UIParent,
	relFrame = UIParent,
	relPoint = "TOPLEFT",
	xOff = 0,
	yOff = 0,
	width = 375,
	height = 400,
	isMovable = true
}
aw.OutputList = aw:createFrame(params);						--Create the Frame
local ScrollWindow = aw:createScrollFrame(aw.OutputList)

local txtLeft = ScrollWindow:CreateFontString( nil, "OVERLAY", "GameFontNormal")
txtLeft:SetPoint("TOPLEFT", aw.OutputList, "TOPLEFT", 15, 80);
txtLeft:SetSize(35, 600);
txtLeft:SetJustifyH("RIGHT");

local txtMid = ScrollWindow:CreateFontString( nil, "OVERLAY", "GameFontNormal")
txtMid:SetPoint("TOPLEFT", txtLeft, "TOPRIGHT", 15, 0);
txtMid:SetSize(190, 600);
txtMid:SetJustifyH("LEFT");

local txtRight = ScrollWindow:CreateFontString( nil, "OVERLAY", "GameFontNormal")
txtRight:SetPoint("TOPLEFT", txtMid, "TOPRIGHT", 15, 0);
txtRight:SetSize(55, 600);
txtRight:SetJustifyH("RIGHT");


local t = "";
for i=1, 30 do
	t = t.. i .. "\n" ;
end;
txtLeft:SetText(t);
txtMid:SetText(t);
txtRight:SetText(t);

local footer = aw.OutputList:CreateFontString(nil, "OVERLAY", "GameFontNormal");
footer:SetPoint("BOTTOMLEFT", 20, 45);
footer:SetText("/aw or /auctionwatch to show this report.");

--Add the buttons and handlers
local w = (params.width -20) / 3;
params = {
	anchor = "BOTTOMRIGHT",
	parent = aw.OutputList,
	relFrame = aw.OutputList,
	relPoint = "BOTTOMRIGHT",
	xOff = -10,
	yOff = 10,
	width = w,
	height = 30,
	caption	= "Swap Sort",
	ttip = "Swap the field being sorted\nNumber of auctions or the \ntime of your last visit to the\nAuction House.",
	pressFunc = function (self) aw:ReportAuctionsToWindow(true); end;
}
aw:createButton(params);
params = {
	anchor = "BOTTOMRIGHT",
	parent = aw.OutputList,
	relFrame = aw.OutputList,
	relPoint = "BOTTOMRIGHT",
	xOff = -10 - w,
	yOff = 10,
	width = w,
	height = 30,
	caption	= "Remove Toon",
	ttip = "Remove a toon from the database.\nIf you remove a toon in error opening\nthe Auction House from that toon\nwill correct this.",
	pressFunc = function (self) aw:RemoveToon(); end;
}
aw:createButton(params);
params = {
	anchor = "BOTTOMRIGHT",
	parent = aw.OutputList,
	relFrame = aw.OutputList,
	relPoint = "BOTTOMRIGHT",
	xOff = -10 - (2 * w),
	yOff = 10,
	width = w,
	height = 30,
	caption	= "Options",
	ttip = "Control where reports go and \nthe way they are displayed.",
	pressFunc = function (self) InterfaceOptionsFrame_OpenToCategory(aw.panel);
								InterfaceOptionsFrame_OpenToCategory(aw.panel); 
				end;
}
aw:createButton(params);



--[[
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
]]

--aw.OutputList:Hide();

--[[
local t = {};		--table of FontStrings placed on the frame
local list = {};	--table of strings to display
aw.button = {};		--array of buttons created at the bottom of the output frame
local currentIndex = 1;

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

end 

-- function aw:ClearAllText()
	-- for i = 1, 20 do		--20 lines
		-- for j = 1, 5 do		--5 positions
			-- t[i][j]:SetText("");
		-- end
	-- end
-- end

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
	if aw.slider == nil then return; end;
	if #list < 1 then return; end;
	aw:ClearAllText();
	aw.slider:SetMinMaxValues(1, #list);
	aw.slider:SetValue(idx);
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





]]