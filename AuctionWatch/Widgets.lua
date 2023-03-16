-- Edited Mar 16, 2023

local addon, aw = ...;
function aw:colorString(c, str)
	local color = 	{ ["red"] = "RED_FONT_COLOR:", ["green"]  = "GREEN_FONT_COLOR:" }
	if str == nil then str = "nil"; end;
	return ("\124cn" .. color[c] .. str);
end;
function aw:myPrint( ... )
	print("\124cFF0088FFAuction Watch: ",  ...);
end;
local frameCount = 0;
function aw:createCheckBox(opts)	
	frameCount = frameCount + 1;		
	if opts.name == nil or opts.name == "" then
		opts.name = addon .. "GeneratedCheckboxNumber" .. frameCount;
	end;
	local cb = CreateFrame("CheckButton", opts.name, opts.parent, "ChatConfigCheckButtonTemplate");
	cb:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts.yOff);
	cb:SetSize(32, 32);	
	local txt = opts.parent:CreateFontString(nil, "OVERLAY", "GameFontWhite");
	txt:SetPoint("BOTTOMLEFT", cb, "BOTTOMRIGHT", 5, 10);
	txt:SetText(opts.caption);	
	cb.tooltip = opts.ttip;	
	return cb, txt;
end
local buttonCount = 0;
function aw:createButton(opts)
	buttonCount = buttonCount + 1;		
	if opts.name == nil or opts.name == "" then
		opts.name = addon .. "GeneratedButtonNumber" .. buttonCount;
	end;	
	local btn = CreateFrame("Button",  opts.name, opts.parent, "GameMenuButtonTemplate");
	btn:SetSize(opts.width, opts.height);
	btn:SetText(opts.caption);
	btn:SetNormalFontObject("GameFontNormalLarge");
	btn:SetHighlightFontObject("GameFontHighlightLarge");
	btn:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts.yOff);
	if (opts.ttip ~= nil) or (opts.ttip ~= "") then 
		btn:SetScript("OnEnter", function()
			GameTooltip:SetOwner(btn, "TOP");
			GameTooltip:AddLine(opts.ttip);
			GameTooltip:Show();
		end);
		btn:SetScript("OnLeave", function() GameTooltip:Hide(); end);
	end;
	if opts.pressFunc ~= nil then 
		btn:SetScript("OnClick", function(self, button, down)
			opts.pressFunc(self, button)
		end)
	end;
	return b;	
end;
local frameCount = 0;
function aw:createFrame(opts)
	frameCount = frameCount + 1;		
	if opts.name == nil or opts.name == "" then
		opts.name = addon .. "GeneratedFrameNumber" .. frameCount;
	end;
	local f = CreateFrame("Frame", opts.name, opts.parent, "UIPanelDialogTemplate"); 
	f:SetSize(opts.width, opts.height);
	f:SetPoint(opts.anchor, opts.relFrame, opts.relPoint, opts.xOff, opts,yOff);
	if opts.title ~= nil then
		f.Title:SetJustifyH("CENTER");
		f.Title:SetText( opts.title );
	end;
	if opts.isMovable then
		f:EnableMouse(true);
		f:SetMovable(true);
		f:SetUserPlaced(false); 
		f:RegisterForDrag("LeftButton");
		f:SetScript("OnDragStart", function(self) self:StartMoving() end);
		f:SetScript("OnDragStop", function(self) 
			self:StopMovingOrSizing(); 
			aWatchDB.point, _, aWatchDB.relativePoint, aWatchDB.xOfs, aWatchDB.yOfs = self:GetPoint(1);
		end);
	end;
	if opts.isResizable then
		f:SetResizable(true);
		f:SetScript("OnMouseDown", function()
			f:StartSizing("BOTTOMRIGHT")
		end);
		f:SetScript("OnMouseUp", function()
			f:StopMovingOrSizing()
		end);
		f:SetScript("OnSizeChanged", OnSizeChanged);
	end;
	return f;		
end;
local sliderCount = 0;
function aw:createSlider(opts)
	sliderCount = sliderCount + 1;		
	if opts.name == nil or opts.name == "" then
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
function aw:createScrollFrame(parent)
	local frameHolder;
	local self = frameHolder or CreateFrame("Frame", nil, parent); 
	self:ClearAllPoints();
	self:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -40);
	self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -10, 60);
	self.scrollframe = self.scrollframe or CreateFrame("ScrollFrame", "awOutputScrollFrame", self, "UIPanelScrollFrameTemplate");
	self.scrollchild = self.scrollchild or CreateFrame("Frame"); 
	local scrollbarName = self.scrollframe:GetName()
	self.scrollbar = _G[scrollbarName.."ScrollBar"];
	self.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"];
	self.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"];
	self.scrollupbutton:ClearAllPoints();
	self.scrollupbutton:SetPoint("TOPRIGHT", self.scrollframe, "TOPRIGHT", 3, -2);
	self.scrolldownbutton:ClearAllPoints();
	self.scrolldownbutton:SetPoint("BOTTOMRIGHT", self.scrollframe, "BOTTOMRIGHT", 3, 2);
	self.scrollbar:ClearAllPoints();
	self.scrollbar:SetPoint("TOP", self.scrollupbutton, "BOTTOM", 0, -2);
	self.scrollbar:SetPoint("BOTTOM", self.scrolldownbutton, "TOP", 0, 2);
	self.scrollframe:SetScrollChild(self.scrollchild);
	self.scrollframe:SetAllPoints(self);
	self.scrollchild:SetSize(self.scrollframe:GetWidth(), ( self.scrollframe:GetHeight() * 4 ));
	return self.scrollchild;
end;
