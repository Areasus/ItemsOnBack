local Framework = exports['pepe-core']:GetCoreObject()

local CurrentBackItems = {}
local TempBackItems = {}
local checking = true
local currentWeapon = nil
local slots = 40
local s = {}
local isActive =false

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
    BackLoop()
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
    resetItems()
end)

RegisterNetEvent("Framework:Client:OnPlayerUnload", function()
    resetItems()
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(450, function()
        TriggerEvent("backitems:start")
    end)
end)


RegisterNetEvent("backitems:start", function()
    Wait(10000)
    BackLoop()
end)

RegisterNetEvent("backitems:displayItems", function(toggle)
    if toggle then 
        for k,v in pairs(TempBackItems) do 
            createBackItem(k)
        end
        BackLoop()
        isActive=true
    else 
        TempBackItems = CurrentBackItems
        checking = false
        for k,v in pairs(CurrentBackItems) do
            removeBackItem(k)
        end
        CurrentBackItems = {}
        isActive = false
    end
end)

function resetItems()
    removeAllBackItems()
    CurrentBackItems = {}
    TempBackItems = {}
    currentWeapon = nil
    s = {}
    checking = false
end

function BackLoop()
    -- print("[Backitems]: Starting Loop")
    checking = true
    CreateThread(function()
        while checking do
            local player = Framework.Functions.GetPlayerData()
            while player == nil do 
                player = Framework.Functions.GetPlayerData()
                Wait(500)
            end
            for i = 1, slots do
                s[i] = player.items[i]
            end
            check()
            Wait(1000)
        end
    end)
end

function check()
    for i = 1, slots do
        if s[i] ~= nil then
            local name = s[i].name
            if BackItems[name] then
                if name ~= currentWeapon then
                    removeAllBackItems()
                    createBackItem(name)
                    break
                end
            end
        end
    end

    for k,v in pairs(CurrentBackItems) do 
        local hasItem = false
        for j = 1, slots do
            if s[j] ~= nil then
                local name = s[j].name
                if name == k then 
                    hasItem = true
                end
            end
        end
        if not hasItem then 
            removeBackItem(k)
        end
    end
end

function createBackItem(item)
    if not CurrentBackItems[item] then
        if BackItems[item] then 
            local i = BackItems[item]
            local model = i["model"]
            local ped = PlayerPedId()
            local bone = GetPedBoneIndex(ped, i["back_bone"])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(10)
            end
            SetModelAsNoLongerNeeded(model)
            CurrentBackItems[item] = CreateObject(GetHashKey(model), 1.0, 1.0, 1.0, true, true, false)   
            local y = i["y"]  
            if Framework.Functions.GetPlayerData().charinfo.gender == 1 then y = y + 0.035 end
            AttachEntityToEntity(CurrentBackItems[item], ped, bone, i["x"], y, i["z"], i["x_rotation"], i["y_rotation"], i["z_rotation"], 0, 1, 0, 1, 0, 1)
            SetEntityCompletelyDisableCollision(CurrentBackItems[item], false, true)		
	end
    end
end

function removeBackItem(item)
    if CurrentBackItems[item] then
        DeleteEntity(CurrentBackItems[item])
        CurrentBackItems[item] = nil
    end
end

function removeAllBackItems()
    for k,v in pairs(CurrentBackItems) do 
        removeBackItem(k)
    end
end

RegisterNetEvent('weapons:client:SetCurrentWeapon', function(weap, shootbool)
    if weap == nil then
        createBackItem(currentWeapon)
        currentWeapon = nil
    else
        if currentWeapon ~= nil then  
            createBackItem(currentWeapon)
            currentWeapon = nil
        end
        currentWeapon = tostring(weap.name)
        removeBackItem(currentWeapon)
    end
end)

RegisterCommand("toggleweapon", function(source, args, rawCommand)

    if isActive then
        TriggerEvent("backitems:displayItems", false)
    else
        TriggerEvent("backitems:displayItems", true)
    end
  
  end)




