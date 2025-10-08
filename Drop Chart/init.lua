local core_mainmenu = require("core_mainmenu")
local N = require("Drop Chart.Rares Normal")
local H = require("Drop Chart.Rares Hard")
local VH = require("Drop Chart.Rares Very Hard")
local U = require("Drop Chart.Rares Ultimate")
local BN = require("Drop Chart.Boxes Normal")
local BH = require("Drop Chart.Boxes Hard")
local BVH = require("Drop Chart.Boxes Very Hard")
local BU = require("Drop Chart.Boxes Ultimate")
local E = require("Drop Chart.Enemies")
local EE = require("Drop Chart.Enemies Extra")
local A = require("Drop Chart.Areas")
local AA = require("Drop Chart.Attributes")
local SD = require("Drop Chart.Set Drop")
local AB = require("Drop Chart.Areas Boxes")
local Q = require("Drop Chart.Quests")
local QB = require("Drop Chart.Quests Boxes")
local S = require("Drop Chart.Short")

local success

local DAR = 100
local RDR = 100
local RER = 100

local QuestName = "Quest"
local QuestUpdate = ""

local D = {N, H, VH, U}
local B = {BN, BH, BVH, BU}
local Dif = 4
local DifList = {"Normal", "Hard", "Very Hard", "Ultimate"}
local SecID = {"Viridia", "Greenill", "Skyly", "Bluefull", "Purplenum", "Pinkal", "Redria", "Oran", "Yellowboze", "Whitill"}
local SecIDColor = {0x7F264000, 0x7F004012, 0x7F3E3E02, 0x7F401800, 0x7F400033, 0x7F250040, 0x7F02023E, 0x7F02203E, 0x7F023E3E}

local Boxes = false
local Total = true

local window_open = false
local button_func = function()
  window_open = not window_open
end

local function present()
    if window_open then
        imgui.SetNextWindowSize(700, 520, "FirstUseEver");
        local s
        s, window_open = imgui.Begin("Drop Chart", window_open)

        local DW = imgui.CalcTextSize("Very Hard") + 32
        local RW = imgui.CalcTextSize("000") + 10
        local QW = imgui.CalcTextSize("This is a testing string")
        local namePad = imgui.CalcTextSize("Crimson Assassin") + 16

        local xStart, yStart = imgui.GetWindowPos()
        local yCursor = imgui.GetCursorPosY() - 8
        xStart = xStart + namePad
        yStart = yStart + yCursor
        local xWin, yWin = imgui.GetWindowSize()
        yWin = yWin - yCursor
        local xCol = (xWin - 6 - namePad) / 10 - 1

        for i = 1, 9, 1 do
            imgui.AddRectFilled(
                xStart + (i - 1) * xCol, yStart,
                xStart + i * xCol, yStart + yWin,
                SecIDColor[i], 0, 0xF)
        end

        imgui.PushItemWidth(DW)
        success, Dif = imgui.Combo("", Dif, DifList, 4)
        imgui.PopItemWidth()

        imgui.SameLine()
        imgui.PushItemWidth(RW)
        success, DAR = imgui.InputInt("DAR", DAR, 0)
        imgui.PopItemWidth()

        imgui.SameLine()
        imgui.PushItemWidth(RW)
        success, RDR = imgui.InputInt("RDR", RDR, 0)
        imgui.PopItemWidth()

        imgui.SameLine()
        imgui.PushItemWidth(RW)
        success, RER = imgui.InputInt("RER", RER, 0)
        imgui.PopItemWidth()

        imgui.SameLine()
        if imgui.Checkbox("Boxes", Boxes) then
            Boxes = not Boxes
        end

        imgui.SameLine()
        if imgui.Checkbox("Total", Total) then
            Total = not Total
        end

        imgui.SameLine()
        imgui.PushItemWidth(QW)
        success, QuestUpdate = imgui.InputText("", QuestUpdate, 100)
        imgui.PopItemWidth()
        if success then
            if S[string.lower(string.gsub(QuestUpdate, "%s+", ""))] ~= nil then
                QuestName = S[string.lower(string.gsub(QuestUpdate, "%s+", ""))]
            elseif Q[QuestUpdate] ~= nil then
                QuestName = Q[QuestUpdate][0]
            else
                QuestName = "Quest"
            end
        end

        local Quest = Q[QuestName]
        local Box = QB[QuestName]

        imgui.SameLine()
        if (imgui.Button('Reset')) then
            QuestUpdate = ""
            QuestName = "Quest"
        end

        imgui.SameLine()
        imgui.Text(QuestName)
        imgui.SameLine()
        imgui.Text("|")
        for i = 1, table.getn(Quest) - 1, 1 do
            imgui.SameLine()
            imgui.Text(A[Q[QuestName][i]])
            if Quest[0] ~= "Default" and A[Quest[i]] ~= "Bosses" then
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.Text(A[Quest[i]] .. ": " .. AA[Quest[i]][Dif])
                    imgui.EndTooltip()
                end
            elseif A[Quest[i]] == "Bosses" then
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    for k = 1, table.getn(Quest["Bosses"]), 2 do
                        imgui.Text(AA[Quest["Bosses"][k]] .. ": " .. AA[AA[Quest["Bosses"][k]]][Dif])
                    end
                    imgui.EndTooltip()
                end
            elseif Quest[0] == "Default" then
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    for k = 1, table.getn(AA[Quest[i]]), 1 do
                        imgui.Text(AA[Quest[i]][k] .. ": " .. AA[AA[Quest[i]][k]][Dif])
                    end
                    imgui.EndTooltip()
                end
            end
            if i ~= table.getn(Quest) - 1 then
                imgui.SameLine(0, 1)
                imgui.Text(",")
            end
        end

        imgui.Columns(11)
        for i = 1, 10, 1 do
            imgui.SetColumnOffset(i, namePad + (i - 1) * xCol)
        end
        for j = 1, 11, 1 do
            imgui.Text("")
            imgui.NextColumn()
        end

        if not Boxes then
            for i = 1, table.getn(Quest) - 1, 1 do
                if Total and Quest[0] ~= "Default" then
                    i = table.getn(Quest)
                end
                if i ~= 1 and i ~= table.getn(Quest) then
                    for j = 1, 22, 1 do
                        imgui.Text("")
                        imgui.NextColumn()
                    end
                end
                --Area Name
                imgui.SetCursorPosX(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize(A[Quest[i]])) / 2)
                imgui.Text(A[Quest[i]])
                if not Total and Quest[0] ~= "Default" and A[Quest[i]] ~= "Bosses" then
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.Text(A[Quest[i]] .. ": " .. AA[Quest[i]][Dif])
                        imgui.EndTooltip()
                    end
                elseif Total and Quest[0] ~= "Default" then
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        for k = 1, table.getn(Quest) - 1, 1 do
                            if A[Quest[k]] ~= "Bosses" then
                                imgui.Text(A[Quest[k]] .. ": " .. AA[Quest[k]][Dif])
                            else
                                for k = 1, table.getn(Quest["Bosses"]), 2 do
                                imgui.Text(AA[Quest["Bosses"][k]] .. ": " .. AA[AA[Quest["Bosses"][k]]][Dif])
                                end
                            end
                        end
                        imgui.EndTooltip()
                    end
                elseif A[Quest[i]] == "Bosses" then
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        for k = 1, table.getn(Quest["Bosses"]), 2 do
                            imgui.Text(AA[Quest["Bosses"][k]] .. ": " .. AA[AA[Quest["Bosses"][k]]][Dif])
                        end
                        imgui.EndTooltip()
                    end
                elseif Quest[0] == "Default" then
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        for k = 1, table.getn(AA[Quest[i]]), 1 do
                            imgui.Text(AA[Quest[i]][k] .. ": " .. AA[AA[Quest[i]][k]][Dif])
                        end
                        imgui.EndTooltip()
                    end
                end
                imgui.NextColumn()
                for j = 1, 10, 1 do
                    --Section ID
                    imgui.SetCursorPosX(imgui.GetCursorPosX() + (xCol - imgui.CalcTextSize(SecID[j]) - 16) / 2)
                    imgui.Text(SecID[j])
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        for k = 1, 10, 1 do
                            imgui.Text(AA["Weapons"][k] .. ": " .. AA[SecID[j]][k])
                        end
                        imgui.EndTooltip()
                    end
                    imgui.NextColumn()
                end
                imgui.Separator()
                local Area = Quest[Quest[i]]
                for j = 1, table.getn(Area), 2 do
                    --Monster Name
                    imgui.SetCursorPosX(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize(E[Area[j]][Dif])) / 2)
                    if Area[j+1] == "" and not (Area[j] == "Al Rappy" or Area[j] == "Hildeblue" or Area[j] == "Nar Lily" or Area[j] == "Pouilly Slime"
                        or Area[j] == "Nar Lily E2" or Area[j] == "Love Rappy" or Area[j] == "St Rappy" or Area[j] == "Hallo Rappy" or Area[j] == "Egg Rappy" or Area[j] == "Hildeblue E2"
                        or Area[j] == "Del Rappy" or Area[j] == "Pazuzu" or Area[j] == "Dorphon Eclair" or Area[j] == "Merissa AA" or Area[j] == "Kondrieu") then
                        local cPosY= imgui.GetCursorPosY()
                        imgui.SetCursorPosY(imgui.GetCursorPosY() + imgui.GetFontSize() / 2)
                        imgui.Text(E[Area[j]][Dif])
                        imgui.SetCursorPosY(cPosY)
                    else
                        imgui.Text(E[Area[j]][Dif])
                    end
                    if Area[j] ~= "Random Mericarol" then
                        if imgui.IsItemHovered() then
                            imgui.BeginTooltip()
                            imgui.Text("Set Drop: " .. SD[Area[j]][Dif])
                            imgui.EndTooltip()
                        end
                    end
                    --Rare Monster Rate
                    if Area[j] == "Al Rappy" or Area[j] == "Hildeblue" or Area[j] == "Nar Lily" or Area[j] == "Pouilly Slime"
                        or Area[j] == "Nar Lily E2" or Area[j] == "Love Rappy" or Area[j] == "St Rappy" or Area[j] == "Hallo Rappy" or Area[j] == "Egg Rappy" or Area[j] == "Hildeblue E2"
                        or Area[j] == "Del Rappy" or Area[j] == "Pazuzu" or Area[j] == "Dorphon Eclair" or Area[j] == "Merissa AA" or Area[j] == "Kondrieu" then
                        local EnemyRER = "1/" .. math.floor(500 / (RER / 100) * 100) / 100
                        if Area[j] == "Kondrieu" then
                            EnemyRER = "1/" .. math.floor(10 / (RER / 100) * 100) / 100
                        end
                        imgui.SetCursorPosX(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize(EnemyRER)) / 2)
                        imgui.Text(EnemyRER)
                        imgui.NextColumn()
                    else
                    --Monster Count
                    imgui.SetCursorPosX(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize(Area[j+1])) / 2)
                    imgui.Text(Area[j+1])
                    imgui.NextColumn()
                    end
                    for k = 1, 40, 4 do
                        --Item Name
                        imgui.SetCursorPosX(imgui.GetCursorPosX() + (xCol - imgui.CalcTextSize(D[Dif][Area[j]][k]) - 16) / 2)
                        imgui.Text(D[Dif][Area[j]][k])
                        --Item Rate
                        local ItemRate = string.sub(D[Dif][Area[j]][k+3], 3)
                        local InX = ItemRate
                        local ItemDAR = string.match(D[Dif][Area[j]][k+1], "%d+", string.len(D[Dif][Area[j]][k+1]) - 4)
                        local ItemRDR = string.match(D[Dif][Area[j]][k+2], "%d+%.%d+", string.len(D[Dif][Area[j]][k+2]) - 10)
                        if tonumber(ItemRate) ~= nil then
                            if DAR / 100 > 100 / ItemDAR then
                                ItemRate = ItemRate / (100 / ItemDAR)
                            else
                                ItemRate = ItemRate / (math.floor((DAR / 100) * ItemDAR) / ItemDAR)
                            end
                            if RDR / 100 > 87.5 / ItemRDR then
                                ItemRate = ItemRate / (87.5 / ItemRDR)
                            else
                                ItemRate = ItemRate / (RDR / 100)
                            end
                            ItemRate = math.floor(ItemRate * 100 + 0.5) / 100
                            imgui.SetCursorPosX(imgui.GetCursorPosX() + (xCol - imgui.CalcTextSize("1/" .. ItemRate) - 16) / 2)
                            imgui.Text("1/" .. ItemRate)
                        else
                            imgui.SetCursorPosX(imgui.GetCursorPosX() + (xCol - imgui.CalcTextSize(D[Dif][Area[j]][k+3]) - 16) / 2)
                            imgui.Text(D[Dif][Area[j]][k+3])
                        end
                        if imgui.IsItemHovered() then
                            imgui.BeginTooltip()
                            local ModDAR = math.min(100, math.floor((DAR / 100) * ItemDAR))
                            local ModRDR = math.min(87.5, math.floor((RDR / 100) * ItemRDR * 100000) / 100000)
                            --Drop Rate
                            imgui.Text(D[Dif][Area[j]][k+1])
                            if DAR > 100 then
                                imgui.SameLine()
                                imgui.TextColored(0, 1, 0, 1, "1/" .. math.floor(100 / ModDAR * 100) / 100 .. " (" .. ModDAR .. "%)")
                            end
                            --Rare Rate
                            imgui.Text(D[Dif][Area[j]][k+2])
                            if RDR > 100 then
                                imgui.SameLine()
                                imgui.TextColored(0, 1, 0, 1, "1/" .. math.floor(100 / ModRDR * 100) / 100 .. " (" .. ModRDR .. "%)")
                            end
                            --Base Rate
                            imgui.Text("Item Rate: " .. D[Dif][Area[j]][k+3])
                            if DAR > 100 or RDR > 100 then
                                imgui.SameLine()
                                imgui.TextColored(0, 1, 0, 1, "1/" .. ItemRate)
                            end
                            --1 in X
                            local MonsterCount = string.match(Area[j+1], "%d+")
                            if MonsterCount ~= nil then
                                imgui.Text("1 in " .. math.floor(InX / MonsterCount * 100) / 100 .. " runs")
                                if DAR > 100 or RDR > 100 then
                                    imgui.SameLine()
                                    imgui.TextColored(0, 1, 0, 1, math.floor(ItemRate / MonsterCount * 100) / 100)
                                end
                            --X per run
                                imgui.Text(math.floor(MonsterCount / InX * 100) / 100 .. " per run")
                                if DAR > 100 or RDR > 100 then
                                    imgui.SameLine()
                                    imgui.TextColored(0, 1, 0, 1, math.floor(MonsterCount / ItemRate * 100) / 100)
                                end
                            end
                            imgui.EndTooltip()
                        end
                        imgui.NextColumn()
                    end
                    imgui.Separator()
                    --Extra Monster
                    if Quest[0] ~= "Default" and (Area[j] == "Rag Rappy" or Area[j] == "Hildebear" or Area[j] == "Poison Lily" or Area[j] == "Pofuilly Slime" or Area[j] == "Pan Arms" or Area[j] == "Bulclaw"
                        or Area[j] == "Poison Lily E2" or Area[j] == "Rag Rappy E2" or Area[j] == "Hildebear E2" or Area[j] == "Pan Arms E2"
                        or Area[j] == "Sand Rappy" or Area[j] == "Zu" or Area[j] == "Dorphon" or Area[j] == "Merissa A" or Area[j] == "Saint Million" or Area[j] == "Shambertin") then
                        for k = 1, table.getn(EE[Area[j]]), 2 do
                            --Monster Name
                            imgui.SetCursorPosX(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize(E[EE[Area[j]][k]][Dif])) / 2)
                            if EE[Area[j]][k+1] == "" and (Area[j] == "Pan Arms" or Area[j] == "Bulclaw" or Area[j] == "Pan Arms E2") then
                                local cPosY= imgui.GetCursorPosY()
                                imgui.SetCursorPosY(imgui.GetCursorPosY() + imgui.GetFontSize() / 2)
                                imgui.Text(E[EE[Area[j]][k]][Dif])
                                imgui.SetCursorPosY(cPosY)
                            else
                                imgui.Text(E[EE[Area[j]][k]][Dif])
                            end
                            if imgui.IsItemHovered() then
                                imgui.BeginTooltip()
                                imgui.Text("Set Drop: " .. SD[EE[Area[j]][k]][Dif])
                                imgui.EndTooltip()
                            end
                            --Rare Monster Rate
                            local EnemyRER = math.floor(500 / (RER / 100) * 100) / 100
                            if Area[j] == "Kondrieu" then
                                EnemyRER = math.floor(10 / (RER / 100) * 100) / 100
                            end
                            if Quest[0] ~= "Default" and (Area[j] == "Rag Rappy" or Area[j] == "Hildebear" or Area[j] == "Poison Lily" or Area[j] == "Pofuilly Slime"
                                or Area[j] == "Poison Lily E2" or Area[j] == "Rag Rappy E2" or Area[j] == "Hildebear E2"
                                or Area[j] == "Sand Rappy" or Area[j] == "Zu" or Area[j] == "Dorphon" or Area[j] == "Merissa A" or Area[j] == "Saint Million" or Area[j] == "Shambertin") then
                                imgui.SetCursorPosX(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize("1/" .. EnemyRER)) / 2)
                                imgui.Text("1/" .. EnemyRER)
                                imgui.NextColumn()
                            else
                            --Monster Count
                            imgui.SetCursorPosX(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize(EE[Area[j]][k+1])) / 2)
                            imgui.Text(EE[Area[j]][k+1])
                            imgui.NextColumn()
                            end
                            for l = 1, 40, 4 do
                                --Item Name
                                imgui.SetCursorPosX(imgui.GetCursorPosX() + (xCol - imgui.CalcTextSize(D[Dif][EE[Area[j]][k]][l]) - 16) / 2)
                                imgui.Text(D[Dif][EE[Area[j]][k]][l])
                                --Item Rate
                                local ItemRate = string.sub(D[Dif][EE[Area[j]][k]][l+3], 3)
                                local InX = ItemRate
                                local ItemDAR = string.match(D[Dif][EE[Area[j]][k]][l+1], "%d+", string.len(D[Dif][EE[Area[j]][k]][l+1]) - 4)
                                local ItemRDR = string.match(D[Dif][EE[Area[j]][k]][l+2], "%d+%.%d+", string.len(D[Dif][EE[Area[j]][k]][l+2]) - 10)
                                if ItemRate ~= nil then
                                    if DAR / 100 > 100 / ItemDAR then
                                        ItemRate = ItemRate / (100 / ItemDAR)
                                    else
                                        ItemRate = ItemRate / (math.floor((DAR / 100) * ItemDAR) / ItemDAR)
                                    end
                                    if RDR / 100 > 87.5 / ItemRDR then
                                        ItemRate = ItemRate / (87.5 / ItemRDR)
                                    else
                                        ItemRate = ItemRate / (RDR / 100)
                                    end
                                    ItemRate = math.floor(ItemRate * 100 + 0.5) / 100
                                    imgui.SetCursorPosX(imgui.GetCursorPosX() + (xCol - imgui.CalcTextSize("1/" .. ItemRate) - 16) / 2)
                                    imgui.Text("1/" .. ItemRate)
                                else
                                    imgui.SetCursorPosX(imgui.GetCursorPosX() + (xCol - imgui.CalcTextSize(D[Dif][EE[Area[j]][k]][l+3]) - 16) / 2)
                                    imgui.Text(D[Dif][EE[Area[j]][k]][l+3])
                                end
                                if imgui.IsItemHovered() then
                                    imgui.BeginTooltip()
                                    local ModDAR = math.min(100, math.floor((DAR / 100) * ItemDAR))
                                    local ModRDR = math.min(87.5, math.floor((RDR / 100) * ItemRDR * 100000) / 100000)
                                    --Drop Rate
                                    imgui.Text(D[Dif][EE[Area[j]][k]][l+1])
                                    if DAR > 100 then
                                        imgui.SameLine()
                                        imgui.TextColored(0, 1, 0, 1, "1/" .. math.floor(100 / ModDAR * 100) / 100 .. " (" .. ModDAR .. "%)")
                                    end
                                    --Rare Rate
                                    imgui.Text(D[Dif][EE[Area[j]][k]][l+2])
                                    if RDR > 100 then
                                        imgui.SameLine()
                                        imgui.TextColored(0, 1, 0, 1, "1/" .. math.floor(100 / ModRDR * 100) / 100 .. " (" .. ModRDR .. "%)")
                                    end
                                    --Base Rate
                                    imgui.Text("Base Rate: " .. D[Dif][EE[Area[j]][k]][l+3])
                                    if DAR > 100 or RDR > 100 then
                                        imgui.SameLine()
                                        imgui.TextColored(0, 1, 0, 1, "1/" .. ItemRate)
                                    end
                                    --1 in X
                                    local MonsterCount = string.match(Area[j+1], "%d+")
                                    if MonsterCount ~= nil then
                                        imgui.Text("1 in " .. math.floor(InX * 500 / MonsterCount * 100) / 100 .. " runs")
                                        if DAR > 100 or RDR > 100 or RER > 100 then
                                            imgui.SameLine()
                                            imgui.TextColored(0, 1, 0, 1, math.floor(ItemRate * EnemyRER / MonsterCount * 100) / 100)
                                        end
                                    --X per run
                                        imgui.Text(math.floor(MonsterCount / (InX * 500) * 100) / 100 .. " per run")
                                        if DAR > 100 or RDR > 100 or RER > 100 then
                                            imgui.SameLine()
                                            imgui.TextColored(0, 1, 0, 1, math.floor(MonsterCount / (ItemRate * EnemyRER) * 100) / 100)
                                        end
                                    end
                                    imgui.EndTooltip()
                                end
                                imgui.NextColumn()
                            end
                            imgui.Separator()
                        end
                    end
                end
                if i == table.getn(Quest) then
                    break
                end
            end
        else
            for i = 1, table.getn(Box), 1 do
                if i ~= 1 then
                    for j = 1, 22, 1 do
                        imgui.Text("")
                        imgui.NextColumn()
                    end
                end
                --Area Name
                imgui.SetCursorPosX(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize(A[Box[i]])) / 2)
                imgui.Text(A[Box[i]])
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.Text(A[Box[i]] .. ": " .. AA[Box[i]][Dif])
                    imgui.EndTooltip()
                end
                imgui.NextColumn()
                for j = 1, 10, 1 do
                    --Section ID
                    imgui.SetCursorPosX(imgui.GetCursorPosX() + (xCol - imgui.CalcTextSize(SecID[j]) - 16) / 2)
                    imgui.Text(SecID[j])
                    imgui.NextColumn()
                end
                imgui.Separator()
                local BoxArea = B[Dif][AB[Box[i]]]
                for j = 1, BoxArea[0] - 1, 1 do
                    imgui.Text("")
                end
                if Box[Box[i]] == "" then
                    imgui.SetCursorPos(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize("Box")) / 2, imgui.GetCursorPosY() + imgui.GetFontSize() / 2)
                    imgui.Text("Box")
                else
                    imgui.SetCursorPosX(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize("Box")) / 2)
                    imgui.Text("Box")
                    imgui.SetCursorPosX(imgui.GetCursorPosX() + (namePad - 16 - imgui.CalcTextSize(Box[Box[i]])) / 2)
                    imgui.Text(Box[Box[i]])
                end
                imgui.NextColumn()
                for j = 1, table.getn(BoxArea), 2 * BoxArea[0] do
                    for k = 0, 2 * BoxArea[0] - 1, 2 do
                        imgui.SetCursorPosX(imgui.GetCursorPosX() + (xCol - imgui.CalcTextSize(BoxArea[j + k]) - 16) / 2)
                        imgui.Text(BoxArea[j + k])
                        imgui.SetCursorPosX(imgui.GetCursorPosX() + (xCol - imgui.CalcTextSize(BoxArea[j + k + 1]) - 16) / 2)
                        imgui.Text(BoxArea[j + k + 1])
                    end
                    imgui.NextColumn()
                end
                imgui.Separator()
            end
        end
        imgui.End()
    end
end

local function init()
  core_mainmenu.add_button("Drop Chart", button_func)

  return {
    name = "Drop Chart",
    version = "2.3",
    author = "Lilyzavoqth",
    description = "Ephinea Drop Chart",
    present = present
  }
end

return {
  __addon = {
    init = init
  }
}
