--aw namespace variable
local addon, aw = ...;
local params = {};

function aw:LoadOptions() 
	aw.ReportChat:SetChecked( aw:GetChat() );
	aw.ReportWindow:SetChecked( aw:GetWindow() );
	aw.ReportChat_Old:SetChecked( aw:GetOnlyOver() );
	aw.ReportWindow_Old:SetChecked(  aw:GetWindowOnlyOver() );
	aw.ByDate:SetChecked( aw:GetByDate() );
	aw.ByCount:SetChecked( not aw:GetByDate() );
	aw.SortAsc:SetChecked( aw:GetAsc() );
	aw.SortDesc:SetChecked( not aw:GetAsc() );
	aw.DaysSlider:SetValue( tonumber(aw:GetDays()) );
	--show/hide the include option based on the value of the ReportChat field
	if aw.ReportChat:GetChecked() == true then aw.ReportChat_Old:Show(); aw.ReportChat_Old_Text:Show();
	else aw.ReportChat_Old:Hide(); aw.ReportChat_Old_Text:Hide();
	end;
	if aw.ReportWindow:GetChecked() == true then aw.ReportWindow_Old:Show(); aw.ReportWindow_Old_Text:Show();
	else aw.ReportWindow_Old:Hide(); aw.ReportWindow_Old_Text:Hide();
	end;
	aw.PlaySound:SetChecked(aw:GetSoundFlag() );
end

local SaveOptions = function()
	aw:SetChat( aw.ReportChat:GetChecked() );
	aw:SetWindow( aw.ReportWindow:GetChecked() );
	aw:SetOnlyOver( aw.ReportChat_Old:GetChecked() );
	aw:SetDays( format( "%i", aw.DaysSlider:GetValue() ) );
	aw:SetAsc( aw.SortAsc:GetChecked() );
	aw:SetByDate( aw.ByDate:GetChecked() );
	aw:SetWindowOnlyOver( aw.ReportWindow_Old:GetChecked() );
	aw:SetSoundFlag(aw.PlaySound:GetChecked() );
end

function cbClicked ()
	if aw.ReportChat:GetChecked() then 
		aw.ReportChat_Old:Show(); aw.ReportChat_Old_Text:Show();
	else 
		aw.ReportChat_Old:Hide(); aw.ReportChat_Old_Text:Hide(); 
	end; 
		--Toggles a secondary option when the primary is selected
	if aw.ReportWindow:GetChecked() then 
		aw.ReportWindow_Old:Show(); aw.ReportWindow_Old_Text:Show();
	else 
		aw.ReportWindow_Old:Hide(); aw.ReportWindow_Old_Text:Hide(); 
	end;
	
end

--Create the ConfigPanel ********************************************************************************
aw.panel = CreateFrame( "Frame", "AWPanel", UIParent );
aw.panel.name = "Auction Watch";	--Name appears in the list to the left of Interface>AddOns
InterfaceOptions_AddCategory(aw.panel);

-- Put the title on the panel
aw.title = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
aw.title:SetPoint("TOPLEFT", 15, -15);
aw.title:SetText("Auction Watch");
-- Place description under the title
aw.description = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontwhiteSmall");
aw.description:SetPoint("TOPLEFT", 15, -40);
aw.description:SetText("These are the settings that control what is included in the report, where it is presented and how it is formated.");

-- Report to chat checkbox
params = {
	parent = aw.panel,
	relFrame = aw.description,
	anchor = "TOPLEFT",
	relPoint = "TOPLEFT",
	xOff = 0,
	yOff = -30,
	caption = "Report to chat.",
	ttip = "Print auction report in the default chat window. \n\nDisabling both reports will still print a single line in chat when you login if you have expired auctions."
}
aw.ReportChat, aw.ReportChat_Text = aw:createCheckBox(params);
aw.ReportChat:SetScript( "OnClick", function() cbClicked(); end);
--Report to window checkbox
params = {
	parent = aw.panel,
	relFrame = aw.ReportChat,
	anchor = "TOPLEFT",
	relPoint = "TOPLEFT",
	xOff = 0,
	yOff = -30,
	caption = "Report to window.",
	ttip = "Print auction report in a window. \n\nDisabling both reports will still print a single line in chat when you login if you have expired auctions."
}
aw.ReportWindow, aw.ReportWindow_Text = aw:createCheckBox(params);
aw.ReportWindow:SetScript( "OnClick", function() cbClicked(); end);
--Only show old checkboxes
params = {
	parent = aw.panel,
	relFrame = aw.ReportChat,
	anchor = "TOPLEFT",
	relPoint = "TOPLEFT",
	xOff = 250,
	yOff = 0,
	caption = "Only show if over.",
	ttip = "Only list the auctions that have gone past the set number of days."
}
aw.ReportChat_Old, aw.ReportChat_Old_Text = aw:createCheckBox(params);
params = {
	parent = aw.panel,
	relFrame = aw.ReportWindow,
	anchor = "TOPLEFT",
	relPoint = "TOPLEFT",
	xOff = 250,
	yOff = 0,
	caption = "Only show window if over.",
	ttip = "Only show the window if auctions have gone past the set number of days."
}
aw.ReportWindow_Old, aw.ReportWindow_Old_Text = aw:createCheckBox(params);
params = {
	parent = aw.panel,
	relFrame = aw.ReportWindow,
	anchor = "TOPLEFT",
	relPoint = "TOPLEFT",
	xOff = 0,
	yOff = -30,
	caption = "Play Raid Warning on very old auctions.",
	ttip = "Play Raid Warning on very old auctions. \n\nIf you haven't been to the auction house for 25 days or more play the raid warning sound at login."
}
aw.PlaySound = aw:createCheckBox(params);

--Sort by title and checkboxes
aw.heading1 = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
aw.heading1:SetPoint("TOPLEFT", aw.ReportWindow, "TOPLEFT", 0, -90);
aw.heading1:SetText("Sort report by:");
--By Date checkbox
params = {
	parent = aw.panel,
	relFrame = aw.heading1,
	anchor = "TOPLEFT",
	relPoint = "TOPLEFT",
	xOff = 0,
	yOff = -20,
	caption = "By Date",
	ttip = "Report is sorted based on when auctions were posted."
}
aw.ByDate, aw.ByDate_Text = aw:createCheckBox(params);
aw.ByDate:SetScript( "OnClick", function(self) 	aw.ByCount:SetChecked(not aw.ByDate:GetChecked()) end);
--By count checkbox
params = {
	parent = aw.panel,
	relFrame = aw.ByDate,
	anchor = "TOPLEFT",
	relPoint = "TOPLEFT",
	xOff = 0,
	yOff = -30,
	caption = "Number of auctions",
	ttip = "Report is sorted based on the number of auctions posted."
}
aw.ByCount = aw:createCheckBox(params);
aw.ByCount:SetScript( "OnClick", function(self) aw.ByDate:SetChecked(not aw.ByCount:GetChecked()); end);
-- Sort ascending checkbox		
aw.SortAsc, aw.SortAsc_Text = CreateCheckBox( aw.panel, aw.ByDate, 250, 0, 
		"Sort Ascending", "The toon with the fewest auctions or most recent visit to the auction house will be listed first." );
aw.SortAsc:SetScript( "OnClick", function(self) aw.SortDesc:SetChecked(not aw.SortAsc:GetChecked()); end);
--Sort descending checkbox
params = {
	parent = aw.panel,
	relFrame = aw.SortAsc,
	anchor = "TOPLEFT",
	relPoint = "TOPLEFT",
	xOff = 0,
	yOff = -30,
	caption = "Sort Descending",
	ttip = "The toon with the most auctions or the longest amount of time since their last visit to the auction house will be listed first."
}
aw.SortDesc, aw.SortDesc_Text = aw:createCheckBox(params);
aw.SortDesc:SetScript( "OnClick", function(self) aw.SortAsc:SetChecked(not aw.SortDesc:GetChecked()); end);	
--Day threshold		
aw.heading2 = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
aw.heading2:SetPoint("TOPLEFT", aw.ByCount, "TOPLEFT", 5, -60);
aw.heading2:SetText("Days allowed before being reminded to check mail");
--Number of days slider
params = {
	parent = aw.panel,
	relFrame = aw.heading2,
	anchor = "TOPLEFT",
	relPoint = "TOPLEFT",
	xOff = 5,
	yOff = -40,
	width = 400,
	height = 20,
	orientation = "HORIZONTAL",	--VERTICAL (side)
	scrollFunc = function(i) ns.MyList:Show(i); end;
}
aw.DaysSlider = ns:createSlider(params);
aw.DaysSlider:SetScript( "OnValueChanged", function (self)
	getglobal(aw.DaysSlider:GetName() .. "Text"):SetText(format( "%i", aw.DaysSlider:GetValue() ) );
end);

params = {};
aw.panel:Hide()

--Panel functions
aw.panel.okay = function (self) SaveOptions(); end;
aw.panel.default = function (self) aw:DefaultSettings(); LoadOptions(); end;

