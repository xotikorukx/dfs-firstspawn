local hasAllResourcesLoaded = false
local hasSpawned = false

function firstSpawnLogic()
    if CONST_DEBUG then
        print("Scanning", GetNumResources(), "resources")
    end

    if CONST_DEBUG then
        print("Player model is", GetEntityModel(PlayerPedId()))
    end

    if GetEntityModel(PlayerPedId()) ~= 225514697--[[0]] then --I think this is the micheal ped?
        if CONST_DEBUG then
            print("Player has spawned, skipping logic")
        end

        hasSpawned = true
        
        return
    end

    local resourceList = {}

    for i=0, GetNumResources() - 1 do
        local resourceName = GetResourceByFindIndex(i)

        if CONST_DEBUG then
            print("Resource", resourceName, "at index", i, "is", GetResourceState(resourceName))
        end

        resourceList[resourceName] = false
    end
    
    while not hasAllResourcesLoaded do
        local awaitingResources = false

        for resourceName, resourceState in pairs(resourceList) do
            if not resourceState then
                local resourceNewState = GetResourceState(resourceName)

                local returnable = true

                if resourceNewState == "starting" or resourceNewState == "stopping" then
                    returnable = false

                    awaitingResources = true
                end

                if CONST_DEBUG and resourceNewState == "uninitialized" or resourceNewState == "missing" or resourceNewState == "unknown" then
                    print("Resource "..resourceName.." is "..resourceNewState)
                end

                resourceList[resourceName] = returnable
            end
        end

        if not awaitingResources then
            hasAllResourcesLoaded = true
        end

        Wait(0)
    end

    if NetworkHasGameBeenAltered() then
        --@TODO: Drop the client or display a message telling them to remove their codeinjector "dinput8.dll"
        return
    end

    while not hasSpawned do
        if NetworkIsSessionStarted() then
            if not IsModelValid(`mp_m_freemode_01`) then
                --@TODO: Yell at someone that there's no mp_male model in the game and to verify their files.
        
                return
            end
        
            RequestModel(`mp_m_freemode_01`)
        
            while not HasModelLoaded(`mp_m_freemode_01`) do
                Wait(0)
            end
        
            local oldPed = PlayerPedId()

            ChangePlayerPed(PlayerId(), CreatePed(0, `mp_m_freemode_01`, 0, 0, 0, 0, true, false), true, true)
            SetEntityCoords(PlayerPedId(), 16.0, 0.0, 71.0, false, false, false, false)
            SetMaxWantedLevel(0)

            DeleteEntity(oldPed)

            hasSpawned = true
        end

        Wait(0)
    end

    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end

local FirstSpawnLogic = firstSpawnLogic

AddEventHandler('construct-core:client:overrideFirstSpawnLogic', function(cb)
    FirstSpawnLogic = cb
end)

Citizen.CreateThread(function()
    FirstSpawnLogic()
end)
