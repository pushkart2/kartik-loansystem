local Framework = {}

if Config.Framework == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()
    local PlayerData = QBCore.Functions.GetPlayerData()

    function Framework:HasAccess()
        for _, v in pairs(Config.BankerJob) do
            if PlayerData.job.name == v then
                return true
            end
        end
        return false
    end

    RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
        PlayerData = val
    end)
end

if Config.Framework == 'esx' then
    local ESX = exports.es_extended:getSharedObject()

    function Framework:HasAccess()
        local data = ESX.GetPlayerData()
        for _, v in pairs(Config.BankerJob) do
            if data.job.name == v then
                return true
            end
        end
        return false
    end

end

if Config.Target == 'qb' then
    function Framework:AddBoxZone(data, index)
        exports['qb-target']:AddBoxZone("loansystem"..index, data.coords, data.length, data.width, {
            name = "loansystem"..index,
            heading = data.heading,
            debugPoly = Config.debug,
            minZ = data.minZ,
            maxZ = data.maxZ,
        }, {
        options = {
            {
                icon = 'fa fa-sitemap',
                label = "Access Bank",
                action = function()
                    OpenMenu()
                end,
                canInteract = function()
                    return not lib.progressActive()
                end,
            },
            {
                icon = 'fa fa-coins',
                label = "Access Banker Menu",
                action = function()
                    OpenBankerMenu()
                end,
                canInteract = function()
                    return Framework:HasAccess() and not lib.progressActive()
                end,
            },
        },
        distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
      })
    end
end

if Config.Target == 'ox' then
    function Framework:AddBoxZone(data, _)
        exports.ox_target:addBoxZone({
            coords = data.coords,
            size = data.size,
            rotation = data.rotation,
            debug = Config.debug,
            options = {
                {

                    icon = 'fa fa-sitemap',
                    label = "Access Bank",
                    onSelect = function()
                        OpenMenu()
                    end,
                    canInteract = function()
                        return not lib.progressActive()
                    end,
                },
                {
                    icon = 'fa fa-coins',
                    label = "Access Banker Menu",
                    onSelect = function()
                        OpenBankerMenu()
                    end,
                    canInteract = function()
                        return Framework:HasAccess() and not lib.progressActive()
                    end,
                },
            }
        })
    end
end

return Framework