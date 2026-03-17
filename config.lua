Config = {}

-- auto / esx / qbcore / standalone
Config.Framework = "auto"
Config.Locale = 'Press X to stand up\nUse arrow keys to change animation'

Debug = function(...)
  print('[DEBUG] '...)
end

Error = function(...)
  print('[ERROR] '...)
end

DetectFramework = function()
    if Config.Framework ~= "auto" then
        return
    end
    if GetResourceState("es_extended") == "started" then
        Config.Framework = "esx"
        Debug("Framework: ESX")
    elseif GetResourceState("qb-core") == "started" then
        Config.Framework = "qbcore"
        Debug("Framework: QBCore")
    else
        Config.Framework = "standalone"
        Error("No frameworks detected, switching to standalone")
    end
end
DetectFramework()
