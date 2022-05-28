local addon, aw = ...;

--**********************************************************************************
--	Checkbox widget
--**********************************************************************************
local frameCount = 0;
function aw:createCheckBox(opts)	
	frameCount = frameCount + 1;		--count each frame created
	if opts.name == nil or opts.name == "" then
		--Unique name generator, addonName + string + counterValue
		opts.name = addon .. "GeneratedCheckboxNumber" .. frameCount;
	end;
	local cb = CreateFrame("CheckButton", opts.name, opts.parent, "ChatConfigCheckButtonTemplate");
	cb:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts.yOff);
	cb:SetSize(32, 32);	
	local txt = opts.parent:CreateFontString(nil, "OVERLAY", "GameFontWhite");
	txt:SetPoint("BOTTOMLEFT", cb, "BOTTOMRIGHT", 5, 10);
	txt:SetText(opts.caption);	
	--cb:SetScript( "OnClick", function() opts.pressFunc() end);
	cb.tooltip = opts.ttip;	
	return cb, txt;
end

--**********************************************************************************
--	Button widget
--**********************************************************************************
local buttonCount = 0;
function aw:createButton(opts)
	buttonCount = buttonCount + 1;		--Counts each button created
	if opts.name == nil or opts.name == "" then
		--Unique name generator, addonName + string + counterValue
		opts.name = addon .. "GeneratedButtonNumber" .. buttonCount;
	end;	
	local btn = CreateFrame("Button",  opts.name, opts.parent, "GameMenuButtonTemplate");
	--position, size and add title to the frame
	btn:SetSize(opts.width, opts.height);
	btn:SetText(opts.caption);
	btn:SetNormalFontObject("GameFontNormalLarge");
	btn:SetHighlightFontObject("GameFontHighlightLarge");
	btn:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts.yOff);
	--Add a tooltip if one was provided
	if (opts.ttip ~= nil) or (opts.ttip ~= "") then 
		btn:SetScript("OnEnter", function()
			GameTooltip:SetOwner(btn, "LEFT");
			GameTooltip:AddLine(opts.ttip);
			GameTooltip:Show();
		end);
		btn:SetScript("OnLeave", function() GameTooltip:Hide(); end);
	end;
	--Button function
	if opts.pressFunc ~= nil then 
		btn:SetScript("OnClick", function(self, button, down)
			opts.pressFunc(self, button)
		end)
	end;
	return b;	
end;

--**********************************************************************************
--	Frame widget
--**********************************************************************************
local frameCount = 0;
function aw:createFrame(opts)
	frameCount = frameCount + 1;		--count each frame created
	if opts.name == nil or opts.name == "" then
		--Unique name generator, addonName + string + counterValue
		opts.name = addon .. "GeneratedFrameNumber" .. frameCount;
	end;
	local f = CreateFrame("Frame", opts.name, opts.parent, "UIPanelDialogTemplate"); 
	f:SetSize(opts.width, opts.height);
	f:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts,yOff);
	if opts.title ~= nil then
		--Add the title if one was provided
		f.Title:SetJustifyH("CENTER");
		f.Title:SetText( opts.title );
	end;
	if opts.isMovable then
		--Make movable if flag set
		f:EnableMouse(true);
		f:SetMovable(true);
		f:SetUserPlaced(true); 
		f:RegisterForDrag("LeftButton");
		f:SetScript("OnDragStart", function(self) self:StartMoving() end);
		f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); end);
	end;
	if opts.isResizable then
		--Make frame Resizable if flag was set
		f:SetResizable(true);
		f:SetScript("OnMouseDown", function()
			f:StartSizing("BOTTOMRIGHT")
		end);
		f:SetScript("OnMouseUp", function()
			f:StopMovingOrSizing()
		end);
		f:SetScript("OnSizeChanged", OnSizeChanged);
	end;
	return f;		--return the frame
end;

--**********************************************************************************
--	Slider widget
--**********************************************************************************
local sliderCount = 0;
function aw:createSlider(opts)
	sliderCount = sliderCount + 1;		--Counts each button created
	if opts.name == nil or opts.name == "" then
		--Unique name generator, addonName + string + counterValue
		opts.name = addon .. "GeneratedSliderNumber" .. sliderCount;
	end
	local slide = CreateFrame("Slider", opts.name, opts.parent, "OptionsSliderTemplate");	
	slide:SetOrientation(opts.orientation);
	slide:SetPoint ("TOPRIGHT", opts.relFrame, "TOPRIGHT", opts.xOff, opts.yOff); 
	slide:SetWidth(opts.width);
	slide:SetHeight(opts.height);	
	getglobal(opts.name .. "Low"):SetText(opts.min);
	getglobal(opts.name .. "High"):SetText(opts.max);	
	if opts.min ~= "" and opts.max ~= "" then slide:SetMinMaxValues(opts.min, opts.max) end;
	slide:SetValueStep(opts.step)
	return slide;
end