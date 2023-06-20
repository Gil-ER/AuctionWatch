-- Edited Jun 20, 2023

local addon, aw = ...;
local params = {};
local 	ReportChat, ReportWindow, ReportChat_Old, ReportWindow_Old, 
		ByDate, ByCount, SortAsc, SortDesc, DaysSlider, PlaySound,
		ReportWindow_Old_Text;
local defaultSettings = { 	
	["Chat"] = false;
	["OnlyOver"] = true; 		
	["Window"] = true; 			
	["WinOnlyOver"] = true;		
	["Days"] = 2; 				
	["Asc"] = false; 			
	["ByDate"] = true; 			
	["PlaySound"] = true }; 	
function aw:LoadOptions() 
	ReportChat:SetChecked( aw:GetSetting("Chat") );
	ReportWindow:SetChecked( aw:GetSetting("Window") );
	ReportChat_Old:SetChecked( aw:GetSetting("OnlyOver") );
	ReportWindow_Old:SetChecked(  aw:GetSetting("WinOnlyOver") );
	ByDate:SetChecked( aw:GetSetting("ByDate") );
	ByCount:SetChecked( not aw:GetSetting("ByDate") );
	SortAsc:SetChecked( aw:GetSetting("Asc") );
	SortDesc:SetChecked( not aw:GetSetting("Asc") );
	if ReportChat:GetChecked() == true then ReportChat_Old:Show(); ReportChat_Old_Text:Show();
		else ReportChat_Old:Hide(); ReportChat_Old_Text:Hide(); end;
	if ReportWindow:GetChecked() == true then ReportWindow_Old:Show(); ReportWindow_Old_Text:Show();
		else ReportWindow_Old:Hide(); ReportWindow_Old_Text:Hide(); end;
	PlaySound:SetChecked(aw:GetSetting("PlaySound") );
	DaysSlider:SetValue( tonumber(aw:GetSetting("Days")) );
	getglobal(DaysSlider:GetName() .. "Text"):SetText(format( "%i", DaysSlider:GetValue() ) );
end
local SaveOptions = function()
end
local function cbClicked ()
	if ReportChat:GetChecked() then ReportChat_Old:Show(); ReportChat_Old_Text:Show();
		else ReportChat_Old:Hide(); ReportChat_Old_Text:Hide(); end; 
	if ReportWindow:GetChecked() then ReportWindow_Old:Show(); ReportWindow_Old_Text:Show();
		else ReportWindow_Old:Hide(); ReportWindow_Old_Text:Hide(); end;
end
aw.panel = CreateFrame( "Frame", "AWPanel", UIParent );
aw.panel.name = "Auction Watch";	
InterfaceOptions_AddCategory(aw.panel);
function aw:ConfigFrame()
	local title = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
	title:SetPoint("TOPLEFT", 15, -15);
	title:SetText("Auction Watch");
	local description = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontwhiteSmall");
	description:SetPoint("TOPLEFT", 15, -40);
	description:SetText("These are the settings that control what is included in the report, where it is presented and how it is formated.");
	params = {
		parent = aw.panel,
		relFrame = description,
		anchor = "TOPLEFT",
		relPoint = "TOPLEFT",
		xOff = 0,
		yOff = -30,
		caption = "Report to chat.",
		ttip = "Print auction report in the default chat window. \n\nDisabling both reports will still print a single line in chat when you login if you have expired auctions."
	}
	ReportChat, _ = aw:createCheckBox(params);
	params = {
		parent = aw.panel,
		relFrame = ReportChat,
		anchor = "TOPLEFT",
		relPoint = "TOPLEFT",
		xOff = 0,
		yOff = -30,
		caption = "Report to window.",
		ttip = "Print auction report in a window. \n\nDisabling both reports will still print a single line in chat when you login if you have expired auctions."
	}
	ReportWindow, _ = aw:createCheckBox(params);
	params = {
		parent = aw.panel,
		relFrame = ReportChat,
		anchor = "TOPLEFT",
		relPoint = "TOPLEFT",
		xOff = 250,
		yOff = 0,
		caption = "Only show if over.",
		ttip = "Only list the auctions that have gone past the set number of days."
	}
	ReportChat_Old, ReportChat_Old_Text = aw:createCheckBox(params);
	params = {
		parent = aw.panel,
		relFrame = ReportWindow,
		anchor = "TOPLEFT",
		relPoint = "TOPLEFT",
		xOff = 250,
		yOff = 0,
		caption = "Only show window if over.",
		ttip = "Only show the window if auctions have gone past the set number of days."
	}
	ReportWindow_Old, ReportWindow_Old_Text = aw:createCheckBox(params);
	params = {
		parent = aw.panel,
		relFrame = ReportWindow,
		anchor = "TOPLEFT",
		relPoint = "TOPLEFT",
		xOff = 0,
		yOff = -30,
		caption = "Play Raid Warning on very old auctions.",
		ttip = "Play Raid Warning on very old auctions. \n\nIf you haven't been to the auction house for 25 days or more play the raid warning sound at login."
	}
	PlaySound = aw:createCheckBox(params);
	heading1 = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
	heading1:SetPoint("TOPLEFT", ReportWindow, "TOPLEFT", 0, -90);
	heading1:SetText("Sort report by:");
	params = {
		parent = aw.panel,
		relFrame = heading1,
		anchor = "TOPLEFT",
		relPoint = "TOPLEFT",
		xOff = 0,
		yOff = -20,
		caption = "By Date",
		ttip = "Report is sorted based on when auctions were posted."
	}
	ByDate, _ = aw:createCheckBox(params);
	params = {
		parent = aw.panel,
		relFrame = ByDate,
		anchor = "TOPLEFT",
		relPoint = "TOPLEFT",
		xOff = 0,
		yOff = -30,
		caption = "Number of auctions",
		ttip = "Report is sorted based on the number of auctions posted."
	}
	ByCount = aw:createCheckBox(params);
	params = {
		parent = aw.panel,
		relFrame = ByDate,
		anchor = "TOPLEFT",
		relPoint = "TOPLEFT",
		xOff = 250,
		yOff = -0,
		caption = "Sort Ascendin",
		ttip = "The toon with the fewest auctions or most recent visit to the auction house will be listed first."
	}
	SortAsc, SortAsc_Text = aw:createCheckBox(params);
	params = {
		parent = aw.panel,
		relFrame = SortAsc,
		anchor = "TOPLEFT",
		relPoint = "TOPLEFT",
		xOff = 0,
		yOff = -30,
		caption = "Sort Descending",
		ttip = "The toon with the most auctions or the longest amount of time since their last visit to the auction house will be listed first."
	}
	SortDesc, _ = aw:createCheckBox(params);	
	local heading2 = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
	heading2:SetPoint("TOPLEFT", ByCount, "TOPLEFT", 5, -60);
	heading2:SetText("Days allowed before being reminded to check mail");
	params = {
		parent = aw.panel,
		relFrame = heading2,
		anchor = "TOPLEFT",
		relPoint = "TOPLEFT",
		xOff = 5,
		yOff = -40,
		width = 400,
		height = 20,
		orientation = "HORIZONTAL",
		min = 1,
		max = 30,
		step = 1
	}
	DaysSlider = aw:createSlider(params);
	aw:LoadOptions();
	ReportChat:SetScript( "OnClick", function() cbClicked(); aw:dbSaveSetting("Chat", ReportChat:GetChecked() ); end);
	ReportChat_Old:SetScript( "OnClick", function() aw:dbSaveSetting("OnlyOver",  ReportChat_Old:GetChecked() ); end);
	ReportWindow:SetScript( "OnClick", function() cbClicked(); aw:dbSaveSetting("Window",  ReportWindow:GetChecked() ); end);
	ReportWindow_Old:SetScript( "OnClick", function() aw:dbSaveSetting("WinOnlyOver",  ReportWindow_Old:GetChecked() ); end);	
	PlaySound:SetScript( "OnClick", function() aw:dbSaveSetting("PlaySound", PlaySound:GetChecked() ); end);
	ByDate:SetScript( "OnClick", function(self) ByCount:SetChecked(not ByDate:GetChecked()); aw:dbSaveSetting("ByDate",  ByDate:GetChecked() ); end);
	ByCount:SetScript( "OnClick", function(self) ByDate:SetChecked(not ByCount:GetChecked()); aw:dbSaveSetting("ByDate",  ByDate:GetChecked() );end);
	SortAsc:SetScript( "OnClick", function(self) SortDesc:SetChecked(not SortAsc:GetChecked()); aw:dbSaveSetting("Asc",  SortAsc:GetChecked() ); end);
	SortDesc:SetScript( "OnClick", function(self) SortAsc:SetChecked(not SortDesc:GetChecked()); aw:dbSaveSetting("Asc",  SortAsc:GetChecked() ); end);
	DaysSlider:SetScript( "OnValueChanged", function (self) 
		getglobal(DaysSlider:GetName() .. "Text"):SetText(format( "%i", DaysSlider:GetValue() ) );
		aw:dbSaveSetting("Days",  format( "%i", DaysSlider:GetValue() ) ); 
	end);	
	getglobal(DaysSlider:GetName() .. "Text"):SetText(format( "%i", DaysSlider:GetValue() ) );	
	params = {};
	aw.panel:Hide()
end;
