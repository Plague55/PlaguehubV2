-- PLague Hub
if game.PlaceId == 12886143095 then

    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
    local Window = OrionLib:MakeWindow({Name = "Crypt Hub", HidePremium = false, SaveConfig = true,IntroTexT = "Plague Hub", ConfigFolder = "PlagueConfig"})
    
    --Values
    
    --Functions
    function summon1()
        game:GetService("ReplicatedStorage").Remotes.Summon:InvokeServer("10","1")
    end
    
    function summon2()
        game:GetService("ReplicatedStorage").Remotes.Summon:InvokeServer("10","2")
    end
    
    function usecodes()
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("BlamTopSecretCodeWontWorkIfNotSubbed")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("GoalReached")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("TyFor1mVisitsPart2")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("TyFor1mVisitsPart1")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("D1SGUISED")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("YammoRework")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("TyFor10kFavREAL")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("NeelsTV")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("FinalDelay")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("RELEASE")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("SorryForDelay")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("Sub2KingLuffy")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("Sub2CodeNex77k")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("Sub2Blamspot524k")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("Sub2HotSauceHan")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("ToadBoi120k")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("BlamsOP5MillionVisitsRerollCodeMustBeSubbedToWorkLOL")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("BlamsAndShocksNightmare100kMemberReRollCodeTrySubscribingToBlamSpotOnYTAndFollowingFr_ShockOnTwitterIfItDoesntWork")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("Update1TrailerHYPE")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("UPDATE1HYPE!")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("50ThousandsFavorites!!!")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("200kMembersINSANE!")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("TyFor25mVisitsOMG!")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("ULTIMATEGOJO")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("BlamSecretValentinesCode")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("BlamSpoyYTSecretUnitCodeMustBeSubbedToWork")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("BlamSpotInsaneWeekendCodeMustBeSubbedToWork")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("SkillTreeRestALPHAReportAnyBugs")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("ALSUpdateIsCooking")
        game:GetService("ReplicatedStorage").Remotes.ClaimCode:InvokeServer("BigUpdateWednesday")

    end
    
    
    --Tabs
    local MainTab = Window:MakeTab({
        Name = "Menu",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    --Toggles
    
    --Buttons
    MainTab:AddButton({
        Name = "Summon 10 (1)",
        Callback = function()
                summon1()
          end    
    })
    
    
    MainTab:AddButton({
        Name = "Summon 10 (2)",
        Callback = function()
                summon2()
          end    
    })
    
    MainTab:AddButton({
        Name = "Use All Codes",
        Callback = function()
                usecodes()
          end    
    })
    
    
    end
    
    OrionLib:Init()
    
    
