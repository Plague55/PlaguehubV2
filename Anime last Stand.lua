local HttpService = game:GetService('HttpService')
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ======================================================================
-- FLEISHUG - Calculator (GETSTOCK V3): Contador de Brainrots (SEM PREÇOS)
-- COMENDO O FLEISHUG
-- ======================================================================
-- Mudanças:
--  - Removida toda a tabela de preços e cálculos de valor
--  - Mantido apenas o CONTADOR total por dono e por servidor
--  - Adicionados mais brainhots à lista de nomes conhecidos
--  - Toggles por nome gerados dinamicamente
--  - Agrupamento por Geração/M/s apenas para ordenar/organizar (sem valores)
-- ======================================================================

-- ========== SISTEMA DE UI SIMPLIFICADO ==========
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove UI existente
if playerGui:FindFirstChild("FleishugUI") then
    playerGui.FleishugUI:Destroy()
end

-- Cria a GUI principal
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "FleishugUI"
mainGui.ResetOnSpawn = false
mainGui.DisplayOrder = 1000
mainGui.Parent = playerGui

-- Frame principal - mais compacto
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = mainGui

-- Corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Header simplificado
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Título simplificado
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🧠 Stock Calculator"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- ScrollFrame para conteúdo
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -70)
scrollFrame.Position = UDim2.new(0, 10, 0, 60)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageTransparency = 0.5
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame

-- Layout para os elementos
local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = scrollFrame

-- Variáveis para controles
local controls = {}
local toggles = {}

-- ========== FUNÇÕES DE UI SIMPLIFICADAS ==========
local function createToggle(name, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = scrollFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -50, 1, 0)
    toggleLabel.Position = UDim2.new(0, 12, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 13
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 25, 0, 15)
    toggleButton.AnchorPoint = Vector2.new(0, 0.5)
    toggleButton.Position = UDim2.new(1, -35, 0.5, 0)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(70, 70, 75)
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(1, 0)
    toggleButtonCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 12, 0, 12)
    toggleCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    toggleCircle.Position = UDim2.new(defaultValue and 0.7 or 0.3, 0, 0.5, 0)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local toggleCircleCorner = Instance.new("UICorner")
    toggleCircleCorner.CornerRadius = UDim.new(1, 0)
    toggleCircleCorner.Parent = toggleCircle
    
    local isToggled = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if isToggled then
            TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 200, 80)}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0.7, 0, 0.5, 0)}):Play()
        else
            TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(70, 70, 75)}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0.3, 0, 0.5, 0)}):Play()
        end
        
        if callback then callback(isToggled) end
    end)
    
    return toggleFrame, function() return isToggled end
end

local function createButton(name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 120, 200)}):Play()
        task.wait(0.1)
        TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
        
        if callback then callback() end
    end)
    
    return button
end

local function createSection(name)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, 0, 0, 25)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Parent = scrollFrame
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, 0, 1, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = name
    sectionLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextSize = 14
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame
    
    return sectionFrame
end

local function showNotification(title, message, duration)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "Notification"
    notifGui.DisplayOrder = 9999
    notifGui.Parent = playerGui
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    notifFrame.AnchorPoint = Vector2.new(1, 0)
    notifFrame.Position = UDim2.new(1, -20, 0, 20)
    notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notifFrame
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -20, 0, 25)
    notifTitle.Position = UDim2.new(0, 10, 0, 5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 16
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.Parent = notifFrame
    
    local notifMessage = Instance.new("TextLabel")
    notifMessage.Size = UDim2.new(1, -20, 0, 40)
    notifMessage.Position = UDim2.new(0, 10, 0, 30)
    notifMessage.BackgroundTransparency = 1
    notifMessage.Text = message
    notifMessage.TextColor3 = Color3.fromRGB(200, 200, 200)
    notifMessage.Font = Enum.Font.Gotham
    notifMessage.TextSize = 12
    notifMessage.TextXAlignment = Enum.TextXAlignment.Left
    notifMessage.TextWrapped = true
    notifMessage.Parent = notifFrame
    
    -- Animação de entrada
    notifFrame.Position = UDim2.new(1, 20, 0, 20)
    local tweenIn = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -20, 0, 20)
    })
    tweenIn:Play()
    
    -- Auto-destruir
    task.spawn(function()
        task.wait(duration or 5)
        local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 0, 20)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notifGui:Destroy()
        end)
    end)
end

getgenv().SAB_CALC = getgenv().SAB_CALC or {
    db_version = 3,
    server_id  = game.JobId,
    scans      = { owners = {} } -- owners[dono] = { owner, pets = {...}, lastScanAt }
}

local function resetDB()
    getgenv().SAB_CALC = {
        db_version = 3,
        server_id  = game.JobId,
        scans      = { owners = {} }
    }
end

local function deepCopy(tbl)
    if type(tbl) ~= "table" then return tbl end
    local res = {}
    for k, v in pairs(tbl) do res[k] = deepCopy(v) end
    return res
end

local function formatTime(ts)
    local ok, d = pcall(os.date, "*t", ts)
    if ok and d then
        return string.format("%02d/%02d/%04d %02d:%02d:%02d", d.day, d.month, d.year, d.hour, d.min, d.sec)
    end
    return tostring(ts)
end

-- ===============================
-- Flags de varredura
-- ===============================
local getSecrets            = false
local getBrainrotGods       = false

-- ===============================
-- Listas de nomes (Secrets): adicionar tudo que a usuária pediu
-- ===============================
-- allowSecretByName controla se cada Secret é incluído na contagem
local allowSecretByName = {
    ["La Sahur Combinasion"]      = true,
    ["Graipuss Medussi"]          = true,
    ["Pot Hotspot"]               = true,
    ["Chicleteira Bicicleteira"]  = true,
    ["La Grande Combinasion"]     = true,
    ["Los Combinasionas"]         = true,
    ["Nuclearo Dinossauro"]       = true,
    ["La Karkerkar Combinasion"]  = true,
    ["Los Hotspotsitos"]          = true,
    ["Tralaledon"]                = true,
    ["Esok Sekolah"]              = true,
    ["Ketupat Kepat"]             = true,
    ["Los Bros"]                  = true,
    ["La Supreme Combinasion"]    = true,
    ["Ketchuru and Musturu"]      = true,
    ["Garama and Madundung"]      = true,
    ["Spaghetti Tualetti"]        = true,
    ["Dragon Cannelloni"]         = true,
    ["Secret Lucky Block"]        = true,
    ["Las Sis"]                   = true,
    ["Celularcini Viciosini"]     = true,
    ["Extinct Tralalero"]         = true,
    ["La Extinct Grande"]         = true,
    ["Tacorita Bicicleta"]        = true,
    ["67"]                        = true,
    ["Quesadilla Crocodila"]      = true,
    
}

-- Usado apenas para reconhecer nomes "conhecidos" (mapeados) como Secret
local knownSecretNames = {}
for name,_ in pairs(allowSecretByName) do
    knownSecretNames[name] = true
end

-- Secret desconhecido (ex.: nomes de Secret que o jogo lançar no futuro)
local allowUnknownSecrets = true

-- ===============================
-- Base M/s (por nome) - apenas para ordenar/entender a mutação se quiser
-- (não influencia preço, pois preços foram removidos)
-- ===============================
local baseMPS = {
    ["Chicleteira Bicicleteira"] = 3.5,
    ["La Grande Combinasion"]    = 10,
    ["Los Combinasionas"]        = 15,
    ["Esok Sekolah"]             = 30,
    ["Graipuss Medussi"]         = 1
}

local multipliers = {
    ["Normal"]  = 1.00,
    ["Gold"]    = 1.25,
    ["Diamond"] = 1.50
}

local MUT_TOLERANCE = 0.10

-- ===============================
-- Utils / Notificações
-- ===============================
local function notification(title, content, image, time)
    showNotification(title, content, time)
end

-- Lista completa de Brainrots conhecidos com valores M/s CORRETOS
local knownBrainrots = {
    ["Pot Hotspot"] = 2.5,
    ["Chicleteira Bicicleteira"] = 3.5,
    ["Los Tralaleritos"] = 0.5,
    ["Las Tralaleritas"] = 0.65,
    ["Graipuss Medussi"] = 1.0,
    ["To to to Sahur"] = 2.2,
    ["Los Chicleteiras"] = 7.0,
    ["La Grande Combinasion"] = 10.0,
    ["Nuclearo Dinossauro"] = 15.0,
    ["Esok Sekolah"] = 30.0,
    ["Money Money Puggy"] = 22.0,
    ["Ketupat Kepat"] = 35.0,
    ["Tictac Sahur"] = 37.5,
    ["Ketchuru and Musturu"] = 42.5,
    ["Garama and Madundung"] = 50.0,
    ["Spaghetti Tualetti"] = 60.0,
    ["La Secret Combinasion"] = 125.0,
    ["Burguro And Fryuro"] = 150.0,
    ["Dragon Cannelloni"] = 200.0,
    ["67"] = 7.5,
    ["Guerriro Digitale"] = 0.55,
    ["Mariachi Corazoni"] = 12.5,
    ["La Extinct Grande"] = 23.5,
    ["Tacorita Bicicleta"] = 16.5,
    ["La Cucaracha"] = 0.475,
    ["Chillin Chili"] = 30.0,
    ["Burrito Bandito"] = 4.0,
    ["Quesadilla Crocodila"] = 3.0,
    ["Los Nooo My Hotspotsitos"] = 5.5,
    ["Chipso and Queso"] = 25.0,
    ["Quesadilla Vampiro"] = 3.5,
    ["La Karkerkar Combinasion"] = 0.6,
    ["La Sahur Combinasion"] = 2.0,
    ["Las Sis"] = 17.5,
    ["Celularcini Viciosini"] = 22.5,
    ["Los Bros"] = 24.0,
    ["Tralaledon"] = 27.5,
    ["Los Tacoritas"] = 32.0,
    ["Los Primos"] = 31.0,
    ["Horegini Boom"] = 2.7,
    ["La Spooky Grande"] = 24.5,
    ["La Vacca Jacko Linterino"] = 0.85,
    ["Los Hotspotsitos"] = 20.0,
    ["Los Combinasionas"] = 15.0,
    ["La Supreme Combinasion"] = 40.0,
    ["Los Mobilis"] = 22.0,
    ["Los Spooky Combanasionias"] = 20.0,
    ["Spooky and Pumpky"] = 80.0,
    ["Eviledon"] = 31.5,
    ["Mieteteira Bicicleteira"] = 26.0,
    ["La Casa Boo"] = 100.0,
    ["Headless Horseman"] = 175.0,
    ["Los Matteos"] = 0.3,
    ["La Vacca Saturno Saturnita"] = 0.3,
    ["Torrtuginni Dragonfrutini"] = 0.35,
    ["Job Job Job Sahur"] = 0.7,
    ["Los Spyderinis"] = 0.425,
    ["Las Vaquitas Saturnitas"] = 0.75
}

local function parseMps(genText)
    if not genText then return 0 end
    -- Tentar extrair B/s primeiro (bilhões/s) - mais preciso
    local bpsMatch = tostring(genText):match("([%d%.]+)B/s")
    if bpsMatch then
        return tonumber(bpsMatch) * 1000 -- Converter B/s para M/s (1B/s = 1000M/s)
    end
    -- Se não tem B/s, tentar M/s
    local mpsMatch = tostring(genText):match("([%d%.]+)M/s")
    return mpsMatch and tonumber(mpsMatch) or 0
end

-- ===============================
-- Scanner MELHORADO (busca múltiplos locais + valores corretos)
-- ===============================
local function getBrainrots()
    local brainrots = {}

    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        return brainrots
    end

    -- Buscar nos plots (método principal)
    for _, plot in pairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild('PlotSign')
        local ownerName =
            sign and sign:FindFirstChild('SurfaceGui') and
            sign.SurfaceGui:FindFirstChild('Frame') and
            sign.SurfaceGui.Frame:FindFirstChild('TextLabel') and
            sign.SurfaceGui.Frame.TextLabel.Text

        if ownerName and plot:FindFirstChild('AnimalPodiums') then
            ownerName = ownerName:gsub("'s Base", ""):gsub("%s+$", "")

            -- Método 1: Buscar nos podiums (método principal)
            for _, podium in pairs(plot.AnimalPodiums:GetChildren()) do
                local overhead = podium:FindFirstChild('Base') and
                              podium.Base:FindFirstChild('Spawn') and
                              podium.Base.Spawn:FindFirstChild('Attachment') and
                              podium.Base.Spawn.Attachment:FindFirstChild('AnimalOverhead')

                if overhead then
                    local rarityObj = overhead:FindFirstChild('Rarity')
                    if rarityObj then
                        local rarityText = rarityObj.Text
                        local shouldInclude = false
                        if getBrainrotGods and rarityText == "Brainrot God" then shouldInclude = true end
                        if getSecrets and rarityText == "Secret" then shouldInclude = true end

                        if shouldInclude then
                            local displayName = overhead:FindFirstChild('DisplayName')
                            local generation = overhead:FindFirstChild('Generation')
                            if displayName and generation then
                                local petName = displayName.Text
                                local petGen = generation.Text

                                -- ===== Filtros específicos para SECRETS =====
                                if rarityText == "Secret" then
                                    if knownSecretNames[petName] then
                                        if allowSecretByName[petName] == false then
                                            petName = nil
                                        end
                                    else
                                        if not allowUnknownSecrets then
                                            petName = nil
                                        end
                                    end
                                end

                                if petName then
                                    -- Extrair M/s do texto de geração (mais preciso)
                                    local mpsValue = parseMps(petGen)
                                    
                                    -- Se não conseguiu extrair, usar valor conhecido como fallback
                                    if mpsValue == 0 and knownBrainrots[petName] then
                                        mpsValue = knownBrainrots[petName]
                                    end
                                    
                                    -- Verificar se não foi adicionado ainda
                                    local alreadyAdded = false
                                    for _, existing in ipairs(brainrots) do
                                        if existing.name == petName and existing.owner == ownerName then
                                            alreadyAdded = true
                                            break
                                        end
                                    end
                                    
                                    if not alreadyAdded then
                                        table.insert(brainrots, {
                                            owner      = ownerName,
                                            name       = petName,
                                            generation = petGen,
                                            rarity     = rarityText,
                                            mps        = mpsValue,
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- Método 2: Buscar diretamente nos Models do plot (para casos onde o brainrot aparece como model)
            for _, child in pairs(plot:GetDescendants()) do
                if child:IsA("StringValue") or child:IsA("Model") then
                    local childName = child.Name
                    
                    -- Verificar se o nome do child corresponde a um brainrot conhecido
                    if knownBrainrots[childName] then
                        -- Verificar se já não foi adicionado
                        local alreadyAdded = false
                        for _, existing in ipairs(brainrots) do
                            if existing.name == childName and existing.owner == ownerName then
                                alreadyAdded = true
                                break
                            end
                        end
                        
                        -- Se não foi adicionado, adicionar agora
                        if not alreadyAdded then
                            local mpsValue = knownBrainrots[childName] or 0
                            
                            -- Tentar pegar M/s de um Generation ou Stats
                            local generationValue = "Unknown"
                            if child and typeof(child) == "Instance" then
                                local genObj = child:FindFirstChild("Generation")
                                if not genObj then
                                    local ok, result = pcall(function()
                                        return child:FindFirstDescendant("Generation")
                                    end)
                                    if ok and result then
                                        genObj = result
                                    end
                                end
                                
                                if genObj and genObj:IsA("StringValue") then
                                    generationValue = genObj.Value
                                    local extractedMps = parseMps(generationValue)
                                    if extractedMps > 0 then
                                        mpsValue = extractedMps
                                    end
                                end
                            end
                            
                            -- Verificar raridade se possível
                            local rarityText = "Secret"
                            if child and typeof(child) == "Instance" then
                                local rarityObj = child:FindFirstChild("Rarity")
                                if not rarityObj then
                                    local ok, result = pcall(function()
                                        return child:FindFirstDescendant("Rarity")
                                    end)
                                    if ok and result then
                                        rarityObj = result
                                    end
                                end
                                
                                if rarityObj and rarityObj:IsA("StringValue") then
                                    rarityText = rarityObj.Value
                                end
                            
                            -- Aplicar filtros de raridade
                            local shouldInclude = false
                            if getBrainrotGods and rarityText == "Brainrot God" then shouldInclude = true end
                            if getSecrets and rarityText == "Secret" then shouldInclude = true end
                            
                            if shouldInclude then
                                table.insert(brainrots, {
                                    name = childName,
                                    generation = generationValue,
                                    owner = ownerName or "Unknown",
                                    mps = mpsValue,
                                    rarity = rarityText
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    
    return brainrots
end

-- ===============================
-- Banco acumulado por dono
-- ===============================
-- Retorna: insertedCount, replacedCount, insertedNames{}, replacedNames{}
local function upsertOwnerScan(scanPets)
    local ownersMap = {}
    for _, pet in ipairs(scanPets) do
        ownersMap[pet.owner] = ownersMap[pet.owner] or {}
        table.insert(ownersMap[pet.owner], deepCopy(pet))
    end

    local ownersDB = getgenv().SAB_CALC.scans.owners
    local replaced, inserted = 0, 0
    local insertedNames, replacedNames = {}, {}

    for owner, pets in pairs(ownersMap) do
        if ownersDB[owner] then
            ownersDB[owner].pets = pets
            ownersDB[owner].lastScanAt = os.time()
            replaced = replaced + 1
            table.insert(replacedNames, owner)
        else
            ownersDB[owner] = {
                owner      = owner,
                pets       = pets,
                lastScanAt = os.time()
            }
            inserted = inserted + 1
            table.insert(insertedNames, owner)
        end
    end
    table.sort(insertedNames, function(a,b) return a:lower() < b:lower() end)
    table.sort(replacedNames, function(a,b) return a:lower() < b:lower() end)
    return inserted, replaced, insertedNames, replacedNames
end

local function computeTotals()
    local ownersDB = getgenv().SAB_CALC.scans.owners
    local totalCount = 0
    for _, entry in pairs(ownersDB) do
        for _ , _p in ipairs(entry.pets) do
            totalCount = totalCount + 1
        end
    end
    return totalCount
end

-- ===============================
-- Formatação por dono (sem preço)
-- ===============================
local function formatPerOwner()
    local ownersDB = getgenv().SAB_CALC.scans.owners
    local out = {}

    local ownerKeys = {}
    for owner in pairs(ownersDB) do table.insert(ownerKeys, owner) end
    table.sort(ownerKeys, function(a,b) return a:lower() < b:lower() end)

    for _, owner in ipairs(ownerKeys) do
        local entry = ownersDB[owner]

        local grouped = {}
        for _, p in ipairs(entry.pets) do
            local key = p.name.."|"..(p.generation or "")
            grouped[key] = grouped[key] or {
                name       = p.name,
                generation = p.generation or "",
                count      = 0,
            }
            local g = grouped[key]
            g.count      = g.count + 1
        end

        local sorted = {}
        for _, g in pairs(grouped) do table.insert(sorted, g) end
        table.sort(sorted, function(a,b)
            return (parseMps(a.generation) or 0) > (parseMps(b.generation) or 0)
        end)

        table.insert(out, string.format('📦 **%s** (último scan: %s)', owner, formatTime(entry.lastScanAt)))
        table.insert(out, '```')
        for _, g in ipairs(sorted) do
            table.insert(out, string.format('%dx %s %s', g.count, g.name, g.generation))
        end
        table.insert(out, '```')
    end

    return out
end

-- ===============================
-- Consolidação servidor (buckets por M+ ou geração; sem valores)
-- ===============================
local function formatServerTotals()
    local ownersDB = getgenv().SAB_CALC.scans.owners
    local groupedAll = {}

    local function pushPet(p)
        local key = p.name or "Unknown"

        groupedAll[key] = groupedAll[key] or {
            name = key,
            buckets = {}, -- [label] = {label, count, sortKey}
            totalCount = 0,
        }

        local mpsValue = p.mps or parseMps(p.generation)
        local label = p.generation or (tostring(mpsValue) .. "M/s")
        local sortKey = mpsValue or 0

        local bk = groupedAll[key].buckets[label]
        if not bk then
            bk = { label = label, count = 0, sortKey = sortKey }
            groupedAll[key].buckets[label] = bk
        end
        bk.count      = bk.count + 1

        groupedAll[key].totalCount  = groupedAll[key].totalCount + 1
    end

    for _, entry in pairs(ownersDB) do
        for _, p in ipairs(entry.pets) do
            pushPet(p)
        end
    end

    local list = {}
    for _, group in pairs(groupedAll) do table.insert(list, group) end
    table.sort(list, function(a,b) return a.name < b.name end)

    local out = {}
    table.insert(out, ' **TODOS OS BRAINROTS DO SERVIDOR (sem preços)**')
    table.insert(out, '```')

    for _, group in ipairs(list) do
        table.insert(out, string.format('%s', group.name))

        local bucketsArr = {}
        for _, r in pairs(group.buckets) do table.insert(bucketsArr, r) end
        table.sort(bucketsArr, function(a,b)
            if a.sortKey == b.sortKey then
                return (a.label or "") > (b.label or "")
            end
            return a.sortKey > b.sortKey
        end)

        for _, r in ipairs(bucketsArr) do
            table.insert(out, string.format('  %s: %d x', r.label, r.count))
        end

        table.insert(out, string.format('  Total: %d x', group.totalCount))
        table.insert(out, '')
    end
    table.insert(out, '```')

    return out
end

local function buildFullReport(filterText)
    local lines = {}

    local perOwner = formatPerOwner()
    for _, l in ipairs(perOwner) do table.insert(lines, l) end

    local serverPart = formatServerTotals()
    for _, l in ipairs(serverPart) do table.insert(lines, l) end

    local totalCount = computeTotals()
    table.insert(lines, '')
    table.insert(lines, ' 📊 Consolidado atual ('..filterText..')')
    table.insert(lines, '  '..string.rep("─", 70))
    table.insert(lines, string.format('  Total: %d brainrots', totalCount))

    local ownersDB = getgenv().SAB_CALC.scans.owners
    local ownersCount = 0
    for _ in pairs(ownersDB) do ownersCount = ownersCount + 1 end
    table.insert(lines, string.rep("─", 72))
    table.insert(lines, ' 📦 TOTAL ACUMULADO (Banco inteiro)')
    table.insert(lines, '  '..string.rep("─", 70))
    table.insert(lines, string.format('  Donos escaneados: %d', ownersCount))
    table.insert(lines, string.format('  Total acumulado: %d brainrots', totalCount))

    return lines, totalCount, ownersCount
end

-- ===============================
-- CRIAR INTERFACE SIMPLIFICADA
-- ===============================

-- Seção principal
createSection("⚙️ Configurações")

-- Toggles gerais
createToggle("Secrets", false, function(value) getSecrets = value end)
createToggle("Brainrot Gods", false, function(value) getBrainrotGods = value end)
createToggle("Unknown Secrets", allowUnknownSecrets, function(value) allowUnknownSecrets = value end)

-- Seção de botões
createSection("🚀 Ações")

-- Botão principal - Scan
createButton("🧠 Scan Stock", function()
    if not getSecrets and not getBrainrotGods then
        notification("Erro", "Ative pelo menos um filtro", nil, 3)
        return
    end

    local filterText = (getSecrets and getBrainrotGods and "Secrets e Brainrot Gods") or
                       (getSecrets and "Secrets") or "Brainrot Gods"

    local scan = getBrainrots()
    if #scan == 0 then
        notification("Vazio", "Nenhum "..filterText:lower().." encontrado", nil, 3)
        return
    end

    local inserted, replaced, insertedNames, replacedNames = upsertOwnerScan(scan)
    local report, totalCount, ownersCount = buildFullReport(filterText)

    print("")
    print("╔══════════════════════════════════════════════════════════════╗")
    print("║                    🧠 BRAINROTS ENCONTRADOS 🧠                ║")
    print("╚══════════════════════════════════════════════════════════════╝")
    for _, line in ipairs(report) do print(line) end

    local clip = table.concat(report, "\n")
    setclipboard(clip)

    notification(
        "Scan concluído",
        string.format("Total: %d brainrots (copiado)", totalCount),
        nil,
        4
    )
end)

-- Botão - Resumo
createButton("📊 Ver Resumo", function()
    local filterText = (getSecrets and getBrainrotGods and "Secrets e Brainrot Gods") or
                       (getSecrets and "Secrets") or
                       (getBrainrotGods and "Brainrot Gods") or
                       "Sem filtro ativo"

    local report, totalCount, ownersCount = buildFullReport(filterText)
    print("")
    print("╔══════════════════════════════════════════════════════════════╗")
    print("║                         RESUMO ATUAL                         ║")
    print("╚══════════════════════════════════════════════════════════════╝")
    for _, line in ipairs(report) do print(line) end

    setclipboard(table.concat(report, "\n"))
    notification("Resumo copiado", "Relatório enviado ao clipboard", nil, 3)
end)

-- Botão - Export TXT
createButton("📄 Export TXT", function()
    local filterText = (getSecrets and getBrainrotGods and "Secrets e Brainrot Gods") or
                       (getSecrets and "Secrets") or
                       (getBrainrotGods and "Brainrot Gods") or
                       "Sem filtro ativo"

    local report, totalCount, ownersCount = buildFullReport(filterText)
    local text = table.concat(report, "\n")

    local hasWrite = (typeof(writefile) == "function")
    local hasIsFolder = (typeof(isfolder) == "function")
    local hasMakeFolder = (typeof(makefolder) == "function")

    local savedWhere = ""

    if hasWrite then
        local dir = "FLEISHUG_Exports"
        if hasIsFolder and not isfolder(dir) and hasMakeFolder then
            makefolder(dir)
        end
        local fname = string.format("%s/export_%d.txt", dir, os.time())
        writefile(fname, text)
        savedWhere = "arquivo: " .. fname
    else
        local folder = workspace:FindFirstChild("FLEISHUG_Exports")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "FLEISHUG_Exports"
            folder.Parent = workspace
        end
        local sv = Instance.new("StringValue")
        sv.Name = "export_" .. tostring(os.time())
        sv.Value = text
        sv.Parent = folder
        savedWhere = "workspace.FLEISHUG_Exports." .. sv.Name .. " (StringValue)"
    end

    setclipboard(text)
    notification("Exportado", "TXT gerado e copiado. Local: "..savedWhere, nil, 5)
    print("[FLEISHUG] Export salvo em: "..savedWhere)
end)

-- Botão - Reset
createButton("🗑️ Limpar Dados", function()
    resetDB()
    notification("OK", "Banco zerado", nil, 3)
end)

-- ========== FINALIZAÇÃO ==========
print("🧠 Stock Calculator carregado com sucesso!")
print("🎨 Interface simplificada ativada!")
print("💡 Configure os filtros e clique em 'Scan Stock' para começar!")
