ESX = exports['es_extended']:getSharedObject()

local function imalAdrenalin()
    local igracinventory = ESX.GetPlayerData().inventory
    for _, item in pairs(igracinventory) do
        if item.name == 'adrenalin' then
            return true
        end
    end
    return false
end

local function jelMrtav(igrac)
    return IsEntityDead(igrac)
end

RegisterNetEvent('anton_adrenalin:koristi')
AddEventHandler('anton_adrenalin:koristi', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local najbliziIgrac, closestDistance = ESX.Game.GetClosestPlayer(coords)

    if najbliziIgrac ~= -1 and closestDistance <= 3.0 then
        local najbliziPed = GetPlayerPed(najbliziIgrac)
        if jelMrtav(najbliziPed) then
            if imalAdrenalin() then
                ESX.TriggerServerCallback('anton_adrenalin:oziviIgraca', function(jeluspeo)
                    if jeluspeo then
                        ESX.ShowNotification('Oživjeli ste najbližeg igrača.')
                    else
                        ESX.ShowNotification('Nije uspjelo oživljavanje.')
                    end
                end, GetPlayerServerId(najbliziIgrac))
            else
                ESX.ShowNotification('Nemate adrenalin u inventaru.')
            end
        else
            ESX.ShowNotification('Najbliži igrač nije mrtav.')
        end
    else
        ESX.ShowNotification('Nema igrača u blizini za oživljavanje.')
    end
end)

exports.qtarget:Player({
  options = {
      {
          icon = "fas fa-medkit",
          label = "Iskoristi adrenalin",
          action = function(entity)
              local najbliziIgrac, closestDistance = ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
              if najbliziIgrac ~= -1 and closestDistance <= 3.0 then
                  local najbliziPed = GetPlayerPed(najbliziIgrac)
                  if imalAdrenalin() and jelMrtav(najbliziPed) then
                      exports['progressbar']:ProgressWithStartEvent({
                          name = "adrenalin",
                          duration = 5000,
                          label = "Koristis adrenalin...",
                          useWhileDead = false,
                          canCancel = true,
                          animation = {
                              animDict = "missheistfbi3b_ig8_2",
                              anim = "cpr_loop_paramedic",
                          },
                      }, function()
                      end, function(canceled)
                        if not canceled then
                          TriggerEvent('anton_adrenalin:koristi')
                        end
                      end, function(canceled)
                          if canceled then
                              ESX.ShowNotification('Oživljavanje otkazano.')
                          end
                      end)
                  else
                      ESX.ShowNotification('Nemate adrenalin ili igrač nije mrtav.')
                  end
              else
                  ESX.ShowNotification('Nema igrača u blizini za oživljavanje.')
              end
          end,
          num = 5
      },
  },
  distance = 2
})