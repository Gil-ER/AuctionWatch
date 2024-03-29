-- Edited Feb 23, 2024

local _, aw = ...;
aw.ID = GetUnitName("player") .. "-" .. GetRealmName();
aw.auctionCount = 0;
SLASH_AUCTIONWATCH1 = "/auctionwatch";
SLASH_AUCTIONWATCH2 = "/aw";
SlashCmdList.AUCTIONWATCH = function(msg)
	aw.OutputList:Show();
end
 AddonCompartmentFrame:RegisterAddon({
	text = "Auction Watch",
	icon = "Interface\\AddOns\\AuctionWatch\\aw.blp",
	notCheckable = true,
	registerForAnyClick = true,
	func = function(btn, arg1, arg2, checked, mouseButton)
		if mouseButton == "LeftButton" then
			aw.OutputList:Show();
			if IsShiftKeyDown() then 
				aw.OutputList:ClearAllPoints();
				aw.OutputList:SetPoint("CENTER", UIParent, "CENTER");
			end;
		elseif mouseButton == "RightButton" then			
			InterfaceOptionsFrame_OpenToCategory(aw.panel);
			InterfaceOptionsFrame_OpenToCategory(aw.panel); 
		end;
	end,
	funcOnEnter = function()
		GameTooltip:SetOwner(AddonCompartmentFrame, "ANCHOR_TOPRIGHT");	
		GameTooltip:AddLine(aw:colorString("white", "     Auction Watch"));
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine("     Left Click - Open Window.     ");		
		GameTooltip:AddLine("     Right Click - Options...     ");
		GameTooltip:AddLine("     <SHIFT> Left Click - Center Window.     ");
		GameTooltip:AddLine(" ");
		GameTooltip:Show();
	end,
	funcOnLeave = function()
		GameTooltip:Hide();
	end,
 })
local frame = CreateFrame("FRAME");
frame:RegisterEvent("SPELLS_CHANGED");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("AUCTION_HOUSE_CLOSED");
frame:RegisterEvent("OWNED_AUCTIONS_UPDATED");
frame:RegisterEvent("AUCTION_HOUSE_AUCTION_CREATED");
function frame:OnEvent(event, arg1, arg2)
	if event == "SPELLS_CHANGED" then
		if aw:VeryOldAuctions() then
			PlaySound(SOUNDKIT.RAID_WARNING);
			aw:myPrint(aw:colorString("red", "*******************************************") );
			aw:myPrint(aw:colorString("red", "   YOU HAVE VERY OLD AUCTIONS") );
			aw:myPrint(aw:colorString("red", "*******************************************") );
		end;
		tinsert(UISpecialFrames, "AuctionWatchReportFrame");	
		tinsert(UISpecialFrames, "AuctionWatchReportFrameNew");		
		frame:UnregisterEvent("SPELLS_CHANGED");				
	end;
	if event == "PLAYER_LOGIN" then 
		aw:ConfigFrame();	
		aw:OutputFrame();
		aw.auctionCount = aw:GetCount(aw.ID);
		if aw:ExpiredAuctions() then 
			aw:myPrint(aw:colorString("red", "You have toons with auctions that need attention.") ); 	
		else
			aw:myPrint(aw:colorString("green", "No toons with auctions that need attention.") ); 	
		end;
		if aw:GetSetting("Window") then 
			if aw:GetSetting("WinOnlyOver") then
				if  aw:ExpiredAuctions() then aw.OutputList:Show(); end;
			else
				aw.OutputList:Show();
			end;
		end;
		if aw:GetSetting("Chat") then aw:ReportAuctionsToChat(); end;	
	end;	
	if event == "OWNED_AUCTIONS_UPDATED" then
		aw.auctionCount = C_AuctionHouse.GetNumOwnedAuctions();
	end;
	if event == "AUCTION_HOUSE_AUCTION_CREATED"  then	
		aw.auctionCount = aw.auctionCount + 1;
	end;
	if event == "AUCTION_HOUSE_CLOSED" then
		if aw.auctionCount > 0 then	aw:UpdateToon(aw.ID); else aw:RemoveToonFromDB(aw.ID); end;
	end;
end	
frame:SetScript("OnEvent", frame.OnEvent);
