local ChairObject = nil
local chairout = false
local currentAnimIndex = 1

local sittingAnims = {
    { dict = "timetable@reunited@ig_10", anim = "base_amanda" },
    { dict = "timetable@maid@couch@", anim = "base" },
    { dict = "timetable@ron@ig_3_couch", anim = "base" },
    { dict = "timetable@jimmy@mics3_ig_15@", anim = "mics3_15_base_tracy" }
}

local function Notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, true)
end

local function loadAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
end

local function GetOffChair()
    local ped = PlayerPedId()

    DetachEntity(ChairObject, true, true)
    ClearPedTasksImmediately(ped)
    DeleteEntity(ChairObject)
    FreezeEntityPosition(ped, false)

    chairout = false

    TriggerServerEvent("portablechair:up")
end

local function SitInChair()
    local ped = PlayerPedId()

    local anim = sittingAnims[currentAnimIndex]
    loadAnim(anim.dict)

    Notify(Config.Locale)

    FreezeEntityPosition(ped, true)
    TaskPlayAnim(ped, anim.dict, anim.anim, 8.0, 8.0, -1, 1, 0, false, false, false)

    CreateThread(function()
        while chairout do
            if IsEntityDead(ped) then
                GetOffChair()
                break
            end

            if IsControlJustPressed(0, 175) then
                currentAnimIndex = currentAnimIndex + 1
                if currentAnimIndex > #sittingAnims then currentAnimIndex = 1 end

                local a = sittingAnims[currentAnimIndex]
                loadAnim(a.dict)
                TaskPlayAnim(ped, a.dict, a.anim, 8.0, 8.0, -1, 1, 0, false, false, false)

            elseif IsControlJustPressed(0, 174) then
                currentAnimIndex = currentAnimIndex - 1
                if currentAnimIndex < 1 then currentAnimIndex = #sittingAnims end

                local a = sittingAnims[currentAnimIndex]
                loadAnim(a.dict)
                TaskPlayAnim(ped, a.dict, a.anim, 8.0, 8.0, -1, 1, 0, false, false, false)
            end

            if IsControlJustPressed(0, 73) then
                GetOffChair()
                break
            end

            Wait(0)
        end
    end)
end

RegisterNetEvent('portablechair:Toggle', function()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, true) then return end

    if not chairout then
        RequestModel("prop_skid_chair_02")
        while not HasModelLoaded("prop_skid_chair_02") do Wait(0) end

        local playerHeading = GetEntityHeading(ped)
        local backPos = GetOffsetFromEntityInWorldCoords(ped, 0.0, -0.6, 0.0)

        local obj = CreateObject(`prop_skid_chair_02`, backPos.x, backPos.y, backPos.z, true, false, false)
        SetEntityHeading(obj, playerHeading + 180.0)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)

        ChairObject = obj
        chairout = true
        currentAnimIndex = 1

        Wait(100)
        SitInChair()
    else
        GetOffChair()
    end
end)
