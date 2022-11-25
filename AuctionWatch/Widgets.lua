local addon, aw = ...;

--**********************************************************************************
--	Utility functions
--**********************************************************************************
function aw:colorString(c, str)
	local color = 	{ ["red"] = "RED_FONT_COLOR:", ["green"]  = "GREEN_FONT_COLOR:" }
	if str == nil then str = "nil"; end;
	return ("\124cn" .. color[c] .. str);
end;
function aw:myPrint( ... )
	print("\124cFF0088FFAuction Watch: ",  ...);
end;

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

--**********************************************************************************
--	Scroll Window widget
--**********************************************************************************
function aw:createScrollFrame(parent)
	local frameHolder;
	 
	-- create the frame that will hold all other frames/objects:
	local self = frameHolder or CreateFrame("Frame", nil, parent); -- re-size this to whatever size you wish your ScrollFrame to be, at this point
	self:ClearAllPoints();
	self:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -30);
	self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -10, 60);
		
	-- now create the template Scroll Frame (this frame must be given a name so that it can be looked up via the _G function (you'll see why later on in the code)
	self.scrollframe = self.scrollframe or CreateFrame("ScrollFrame", "ANewScrollFrame", self, "UIPanelScrollFrameTemplate");
	 
	-- create the standard frame which will eventually become the Scroll Frame's scrollchild
	-- importantly, each Scroll Frame can have only ONE scrollchild
	self.scrollchild = self.scrollchild or CreateFrame("Frame"); -- not sure what happens if you do, but to be safe, don't parent this yet (or do anything with it)
	 
	-- define the scrollframe's objects/elements:
	local scrollbarName = self.scrollframe:GetName()
	self.scrollbar = _G[scrollbarName.."ScrollBar"];
	self.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"];
	self.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"];
	 
	-- all of these objects will need to be re-anchored (if not, they appear outside the frame and about 30 pixels too high)
	self.scrollupbutton:ClearAllPoints();
	self.scrollupbutton:SetPoint("TOPRIGHT", self.scrollframe, "TOPRIGHT", 3, -2);
	 
	self.scrolldownbutton:ClearAllPoints();
	self.scrolldownbutton:SetPoint("BOTTOMRIGHT", self.scrollframe, "BOTTOMRIGHT", 3, 2);
	 
	self.scrollbar:ClearAllPoints();
	self.scrollbar:SetPoint("TOP", self.scrollupbutton, "BOTTOM", 0, -2);
	self.scrollbar:SetPoint("BOTTOM", self.scrolldownbutton, "TOP", 0, 2);
	 
	-- now officially set the scrollchild as your Scroll Frame's scrollchild (this also parents self.scrollchild to self.scrollframe)
	-- IT IS IMPORTANT TO ENSURE THAT YOU SET THE SCROLLCHILD'S SIZE AFTER REGISTERING IT AS A SCROLLCHILD:
	self.scrollframe:SetScrollChild(self.scrollchild);
	 
	-- set self.scrollframe points to the first frame that you created (in this case, self)
	self.scrollframe:SetAllPoints(self);
	 
	-- now that SetScrollChild has been defined, you are safe to define your scrollchild's size.
	self.scrollchild:SetSize(self.scrollframe:GetWidth(), ( self.scrollframe:GetHeight() * 8 ));
	
	return self.scrollchild;
end;


