local QBCore = exports['qb-core']:GetCoreObject()

local speedLimit = nil
local isActive = false
local currentVehicle = nil

local function Notify(msg, type)
    QBCore.Functions.Notify(msg, type or "primary")
end

RegisterCommand("hızsabitle", function(source, args) -- komutu burdan değiştirebilirsiniz/you can change the command here
    local ped = PlayerPedId()

    if not IsPedInAnyVehicle(ped, false) then
        Notify("Aracta olman gerekiyor", "error")
        return
    end

    local vehicle = GetVehiclePedIsIn(ped, false)
    local speed = tonumber(args[1])

    if not speed then
        Notify("Ornek: /hızsabitle 80", "error")
        return
    end

    if speed <= 0 then
        if currentVehicle and DoesEntityExist(currentVehicle) then
            local defaultMax =
                GetVehicleHandlingFloat(
                    currentVehicle,
                    "CHandlingData",
                    "fInitialDriveMaxFlatVel"
                )
            SetVehicleMaxSpeed(currentVehicle, defaultMax)
        end

        speedLimit = nil
        isActive = false
        currentVehicle = nil

        Notify("Hiz sabitleyici kapatildi", "error")
        return
    end

    
    speedLimit = speed / 3.6  -- huda göre ayar/adjust speed
    isActive = true
    currentVehicle = vehicle

    Notify("Hiz sabitlendi: " .. speed .. " km/h", "success")
end)

CreateThread(function()
    while true do
        Wait(500)
        if isActive and currentVehicle then
            if DoesEntityExist(currentVehicle) then
                SetVehicleMaxSpeed(currentVehicle, speedLimit)
            else
                isActive = false
                speedLimit = nil
                currentVehicle = nil
            end
        end
    end
end)
