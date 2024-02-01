local Utils             = require("lua_simple_conditions.utils.simple_conditions_utils")

local Auras             = require("lua_player_aura.entity.player_aura_entity"):new():load()

local PlayerAuras =  {
    Data = "PlayerAuras",
}

function PlayerAuras.handleEvent(player, condition_id)
    if (condition_id) then
        local playerData       = player:GetData(PlayerAuras.Data)

        local aura = Auras.simple_condition:GetCollectionByCondition(condition_id).results
        if ( not aura ) then return end

        if (playerData) then
            if (playerData ~= aura) then
                PlayerAuras.UpdateAura(player, playerData, true)
                PlayerAuras.UpdateAura(player, aura, false)
            end
        else
            PlayerAuras.UpdateAura(player, aura, false)
        end
    else
        local playerData = player:GetData(PlayerAuras.Data)
        if (playerData) then
            PlayerAuras.UpdateAura(player, playerData, true)
            player:SetData(PlayerAuras.Data, nil)
        end
    end
end

function PlayerAuras.UpdateAura( player, data, reset )
    player:SetData( PlayerAuras.Data, data )

    local toAdd = true
    if reset then toAdd = not toAdd end
    for _, aura in pairs( data ) do
        local aura_id = aura:GetAuraId()
        local has_aura = player:HasAura( aura_id )

        if ( reset ) then
            if ( has_aura ) then
                player:RemoveAura( aura_id )
            end
        else
            if ( not has_aura ) then
                local stack = aura:GetStack()
                player:AddAura( aura_id, player ):SetStackAmount( stack )
            end
        end
    end
end

Utils.InitAndAddCallbackIn( PlayerAuras.handleEvent, Auras.simple_condition )