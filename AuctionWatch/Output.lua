-- Edited Mar 16, 2023

local addon, aw = ...;
local lineSpacing = 6;
local frameOpen = false;
function aw:OutputFrame()
	if frameOpen then return; end;
	local params = {
		title = "Last visit to the auction house",
		name = "AuctionWatchReportFrameNew",
		anchor = "TOPLEFT",
		parent = UIParent,
		relFrame = UIParent,
		relPoint = "TOPLEFT",
		xOff = 0,
		yOff = 0,
		width = 425,
		height = 400,
		isMovable = true
	}
	aw.OutputList = aw:createFrame(params);						
	local ScrollWindow = aw:createScrollFrame(aw.OutputList)
	local txtAuctions = ScrollWindow:CreateFontString( nil, "OVERLAY", "GameFontNormal")
	txtAuctions:SetPoint("TOPLEFT", ScrollWindow, "TOPLEFT", 20, 0);
	txtAuctions:SetWidth(35);
	txtAuctions:SetSpacing(lineSpacing);
	txtAuctions:SetJustifyH("RIGHT");
	txtAuctions:SetJustifyV("TOP");
	txtAuctions:EnableMouse(true);
	txtAuctions:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(ScrollWindow, "ANCHOR_CURSOR");
		GameTooltip:SetText("Total number of\nauctions listed.");
		GameTooltip:Show();
	end)
	txtAuctions:SetScript("OnLeave", function() GameTooltip:Hide(); end)
	local txtName = ScrollWindow:CreateFontString( nil, "OVERLAY", "GameFontNormal")
	txtName:SetPoint("TOPLEFT", txtAuctions, "TOPRIGHT", 15, 0);
	txtName:SetWidth(185);
	txtName:SetSpacing(lineSpacing);
	txtName:SetJustifyH("LEFT");
	txtName:SetJustifyV("TOP");
	local txtDay = ScrollWindow:CreateFontString( nil, "OVERLAY", "GameFontNormal")
	txtDay:SetPoint("TOPLEFT", txtName, "TOPRIGHT", 15, 0);
	txtDay:SetWidth(55);
	txtDay:SetSpacing(lineSpacing);
	txtDay:SetJustifyH("RIGHT");
	txtDay:SetJustifyV("TOP");
	txtDay:EnableMouse(true);
	txtDay:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(ScrollWindow, "ANCHOR_CURSOR");
		GameTooltip:SetText("Time since you\nlast visited the\nauction house.");
		GameTooltip:Show();
	end)
	txtDay:SetScript("OnLeave", function() GameTooltip:Hide(); end)
	local txtHrs = ScrollWindow:CreateFontString( nil, "OVERLAY", "GameFontNormal")
	txtHrs:SetPoint("TOPLEFT", txtDay, "TOPRIGHT", 15, 0);
	txtHrs:SetWidth(30);
	txtHrs:SetSpacing(lineSpacing);
	txtHrs:SetJustifyH("RIGHT");
	txtHrs:SetJustifyV("TOP");
	txtHrs:EnableMouse(true);
	txtHrs:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(ScrollWindow, "ANCHOR_CURSOR");
		GameTooltip:SetText("Time since you\nlast visited the\nauction house.");
		GameTooltip:Show();
	end)
	txtHrs:SetScript("OnLeave", function() GameTooltip:Hide(); end)
	local txtMin = ScrollWindow:CreateFontString( nil, "OVERLAY", "GameFontNormal")
	txtMin:SetPoint("TOPLEFT", txtHrs, "TOPRIGHT");
	txtMin:SetWidth(40);
	txtMin:SetSpacing(lineSpacing);
	txtMin:SetJustifyH("LEFT");
	txtMin:SetJustifyV("TOP");
	txtMin:EnableMouse(true);
	txtMin:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(ScrollWindow, "ANCHOR_CURSOR");
		GameTooltip:SetText("Time since you\nlast visited the\nauction house.");
		GameTooltip:Show();
	end)
	txtMin:SetScript("OnLeave", function() GameTooltip:Hide(); end)
	local footer = aw.OutputList:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	footer:SetPoint("BOTTOMLEFT", 20, 45);
	footer:SetText("/aw or /auctionwatch to show this report.");
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
		pressFunc = function (self) 
			local a, n, d, h, m = aw:GetAuctions( true );
			txtAuctions:SetText(a);
			txtName:SetText(n);
			txtDay:SetText(d);
			txtHrs:SetText(h);
			txtMin:SetText(m);
		end;
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
		pressFunc = function (self) aw:RemoveToon(txtName); end;
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
	aw.OutputList:SetScript("OnShow", function(self)
		local a, n, d, h, m = aw:GetAuctions();
		txtAuctions:SetText(a);		
		txtName:SetText(n);			
		txtDay:SetText(d);			
		txtHrs:SetText(h);			
		txtMin:SetText(m);			
		self:ClearAllPoints();
		self:SetPoint(aWatchDB.point or "TOPLEFT", UIParent, aWatchDB.relativePoint or "TOPLEFT", aWatchDB.xOfs or 0, aWatchDB.yOfs or 0);
		self:SetFrameStrata("DIALOG");
	end)
	frameOpen = true;
	aw.OutputList:Hide();
end;
function aw:GetListedToon(tb)
	local i = 1;
	local toons = {};
	local name, list = "", tb:GetText();
	while list do
		name, list = strsplit("\n", list, 2);
		toons[i] = name;
		i = i + 1;
	end;
	return toons;
end
