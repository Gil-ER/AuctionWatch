--aw namespace variable
local _, aw = ...;

aw.ID = GetUnitName("player") .. "-" .. GetRealmName();
aw.auctionCount = 0;

SLASH_AUCTIONWATCH1 = "/auctionwatch";
SLASH_AUCTIONWATCH2 = "/aw";
SlashCmdList.AUCTIONWATCH = function(msg)
	aw:ReportAuctionsToWindow();
end

-- **********************************************************************
-- Event Frame
-- **********************************************************************
local frame = CreateFrame("FRAME");
frame:RegisterEvent("SPELLS_CHANGED");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("AUCTION_HOUSE_CLOSED");
frame:RegisterEvent("OWNED_AUCTIONS_UPDATED");
frame:RegisterEvent("AUCTION_HOUSE_AUCTION_CREATED");

function frame:OnEvent(event, arg1, arg2)
	if event == "SPELLS_CHANGED" then
	--Play Raid Warning if there are really old auctions
		if (not RW_Sounded) and aw:VeryOldAuctions() then
			PlaySound(SOUNDKIT.RAID_WARNING);
			aw:myPrint(aw:colorString("red", "*******************************************") );
			aw:myPrint(aw:colorString("red", "   YOU HAVE VERY OLD AUCTIONS") );
			aw:myPrint(aw:colorString("red", "*******************************************") );
		end;
		tinsert(UISpecialFrames, "AuctionWatchReportFrame");	--Close with ESC key
		frame:UnregisterEvent("SPELLS_CHANGED");
	end;
	
	if event == "PLAYER_LOGIN" then 
		aw:VerifyDatabase()
		aw.auctionCount = aw:GetCount(aw.ID);
		--Single line report on login
		if aw:ExpiredAuctions() then 
			aw:myPrint(aw:colorString("red", "You have toons with auctions that need attention.") ); 	
		else
			aw:myPrint(aw:colorString("green", "No toons with auctions that need attention.") ); 	
		end;
		--Report to Window
		if aw:GetWindow() then 
			if aw:GetWindowOnlyOver() then
				if  aw:ExpiredAuctions() then aw:ReportAuctionsToWindow(); end;
			else
				aw:ReportAuctionsToWindow(); 
			end;
		end;
		--Report to chat
		if aw:GetChat() then aw:ReportAuctionsToChat(); end;		
		aw.LoadOptions();
	end 
	
	if event == "OWNED_AUCTIONS_UPDATED" then
		aw.auctionCount = C_AuctionHouse.GetNumOwnedAuctions();
	end
	
	if event == "AUCTION_HOUSE_AUCTION_CREATED"  then	
		--Posting in the default UI doesn't call OWNED_AUCTIONS_UPDATED
		--C_AuctionHouse.GetNumOwnedAuctions() isn't incremented here
		--This workaround will count an extra auction if you post a commodity when you already have some posted
		if AuctionHouseFrame.ItemSellFrame:IsVisible() == true then aw.auctionCount = aw.auctionCount + 1; end;
	end
		
	if event == "AUCTION_HOUSE_CLOSED" then
		if aw.auctionCount > 0 then	aw:UpdateToon(aw.ID); else aw:RemoveToonFromDB(aw.ID); end;
	end
end	
frame:SetScript("OnEvent", frame.OnEvent);


	
