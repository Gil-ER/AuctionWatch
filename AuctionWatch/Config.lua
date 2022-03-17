--aw namespace variable
local _, aw = ...;

local CreateCheckBox = function ( parent, anchor, xOfset, yOfset, heading, ttip )
	--Creates a checkbox, sizes it, positions it and adds a tooltip
		--name:		Global name for this checkbox
		--parent:	Parent frame for the checkbox (CreateFrams)
		--anchor:	frame refrenced to positioning (SetPoint)
		--xOfset, yOfset: Offsets used in SetPoint
		--heading:	Text that appears right of the box
		--ttip:		Tooltip text
	--The first button is located at the bottom left of the frame
	--Further buttons are added to the left of the previous
	local cb = CreateFrame("CheckButton", name, parent, "ChatConfigCheckButtonTemplate");
	cb:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOfset, yOfset);
	cb:SetSize(32, 32);	
	local txt = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontWhite");
	txt:SetPoint("BOTTOMLEFT", cb, "BOTTOMRIGHT", 5, 10);
	txt:SetText(heading);	
	cb.tooltip = ttip;
	return cb, txt;
end

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
	aw.PlaySound:SetChecked(aw:GetSoundFlag() )
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

--Creat the ConfigPanel ********************************************************************************
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
aw.ReportChat, aw.ReportChat_Text = CreateCheckBox( aw.panel, aw.description, 0, -30, 
		"Report to chat.", "Print auction report in the default chat window. \n\nDisabling both reports will still print a single line in chat when you login if you have expired auctions." );
aw.ReportChat:SetScript( "OnClick", function(self)
	--Toggles a secondary option when the primary is selected
	if aw.ReportChat:GetChecked() then aw.ReportChat_Old:Show(); aw.ReportChat_Old_Text:Show();
	else aw.ReportChat_Old:Hide(); aw.ReportChat_Old_Text:Hide(); end;
end);	
--Report to window checkbox
aw.ReportWindow, aw.ReportWindow_Text = CreateCheckBox( aw.panel, aw.ReportChat, 0, -30, 
		"Report to window.", "Print auction report in a window. \n\nDisabling both reports will still print a single line in chat when you login if you have expired auctions." );
aw.ReportWindow:SetScript( "OnClick", function(self)
	--Toggles a secondary option when the primary is selected
	if aw.ReportWindow:GetChecked() then aw.ReportWindow_Old:Show(); aw.ReportWindow_Old_Text:Show();
	else aw.ReportWindow_Old:Hide(); aw.ReportWindow_Old_Text:Hide(); end;
end);
		
--Only show old checkboxes
aw.ReportChat_Old, aw.ReportChat_Old_Text = CreateCheckBox( aw.panel, aw.ReportChat, 250, 0, 
		"Only show if over.", "Only list the auctions that have gone past the set number of days." );
		
aw.ReportWindow_Old, aw.ReportWindow_Old_Text = CreateCheckBox( aw.panel, aw.ReportWindow, 250, 0, 
		"Only show window if over.", "Only show the window if auctions have gone past the set number of days." );
	
--Play sound on very old auctions checkbox
aw.PlaySound = CreateCheckBox( aw.panel, aw.ReportWindow, 0, -30, 
		"Play Raid Warning on very old auctions.", "Play Raid Warning on very old auctions. \n\nIf you haven't been to the auction house for 25 days or more play the raid warning sound at login." );

	
--Sort by title and checkboxes
aw.heading1 = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
aw.heading1:SetPoint("TOPLEFT", aw.ReportWindow, "TOPLEFT", 0, -90);
aw.heading1:SetText("Sort report by:");
--By Date checkbox
aw.ByDate, aw.ByDate_Text = CreateCheckBox( aw.panel, aw.heading1, 0, -20, 
		"By Date", "Report is sorted based on when auctions were posted." );
aw.ByDate:SetScript( "OnClick", function(self) 
	aw.ByCount:SetChecked(not aw.ByDate:GetChecked());
end); 
--By count checkbox
aw.ByCount, aw.ByCount_Text = CreateCheckBox( aw.panel, aw.ByDate, 0, -30, 
		"Number of auctions", "Report is sorted based on the number of auctions posted." );
aw.ByCount:SetScript( "OnClick", function(self) 
	aw.ByDate:SetChecked(not aw.ByCount:GetChecked());
end); 
-- Sort ascending checkbox		
aw.SortAsc, aw.SortAsc_Text = CreateCheckBox( aw.panel, aw.ByDate, 250, 0, 
		"Sort Ascending", "The toon with the fewest auctions or most recent visit to the auction house will be listed first." );
aw.SortAsc:SetScript( "OnClick", function(self) 
	aw.SortDesc:SetChecked(not aw.SortAsc:GetChecked());
end);		
--Sort descending checkbox
aw.SortDesc, aw.SortDesc_Text = CreateCheckBox( aw.panel, aw.SortAsc, 0, -30, 
		"Sort Descending", "The toon with the most auctions or the longest amount of time since their last visit to the auction house will be listed first." );
aw.SortDesc:SetScript( "OnClick", function(self) 
	aw.SortAsc:SetChecked(not aw.SortDesc:GetChecked());
end);				
--Day threshold		
aw.heading2 = aw.panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
aw.heading2:SetPoint("TOPLEFT", aw.ByCount, "TOPLEFT", 5, -60);
aw.heading2:SetText("Days allowed before being reminded to check mail");
--Number of days slider
aw.DaysSlider = CreateFrame("Slider", "AWconfig_Days_Slider", aw.panel, "OptionsSliderTemplate");
aw.DaysSlider:SetOrientation("HORIZONTAL");
aw.DaysSlider:SetPoint ("TOPLEFT", aw.heading2, "TOPLEFT", 5, -40); 
aw.DaysSlider:SetWidth(400);
aw.DaysSlider:SetHeight(20); 
aw.DaysSlider.tooltip = "Set the number of days after your last auction house visit that you want warnings to start";
getglobal(aw.DaysSlider:GetName() .. "Low"):SetText("1");
getglobal(aw.DaysSlider:GetName() .. "High"):SetText("30");
aw.DaysSlider:SetMinMaxValues(1, 30);
aw.DaysSlider:SetValueStep(1);
aw.DaysSlider:SetValue(2);
getglobal(aw.DaysSlider:GetName() .. "Text"):SetText(format( "%i", aw.DaysSlider:GetValue() ) );
aw.DaysSlider:SetScript( "OnValueChanged", function (self)
	getglobal(aw.DaysSlider:GetName() .. "Text"):SetText(format( "%i", aw.DaysSlider:GetValue() ) );
end);
aw.panel:Hide()

--Panel functions
aw.panel.okay = function (self) SaveOptions(); end;
aw.panel.default = function (self) aw:DefaultSettings(); LoadOptions(); end;

