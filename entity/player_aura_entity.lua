--- Requirement
---
local SimpleConditions  = {
    Utils   = require("lua_simple_conditions.utils.simple_conditions_utils"),
    Entity  = require("lua_simple_conditions.entity.simple_conditions_entity")
}

local Helper = require("lua_player_aura.helper.player_aura_helper")

--- Private functions
local format = string.format

--- Statistic
local Aura = {}

function Aura:new(data)
    local instance = { }
    setmetatable(instance, self)

    -- Reflection for auto-generate method
    for name, _ in pairs(data) do
        local methodName = "Get" .. SimpleConditions.Utils.ToCamelCase(name:sub(1,1):upper() .. name:sub(2))
        instance[methodName] = function (self, value)
            return data[name]
        end
    end

    return instance
end

--- Public methods
local Auras = { }

function Auras:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self

    -- Load Simple Condition Entity
    self.simple_condition = SimpleConditions.Entity

    -- Reflection for auto-generate method
    for _, method in ipairs( Helper.ENUM.METHOD ) do
        local methodName = "GetBy" .. SimpleConditions.Utils.ToCamelCase(method:sub(1,1):upper() .. method:sub(2))
        instance[methodName] = function (self, value)
            if ( self.results ) then
                self.results = self.results[ value ]
            end
            return self
        end
    end

    return instance
end

function Auras:loadAuras()
    WorldDBQuery( format( Helper.DATABASE.AURAS.CREATE, Helper.DATABASE.NAME ) )

    local query = WorldDBQuery( format( Helper.DATABASE.AURAS.READ, Helper.DATABASE.NAME ) )
    if ( query ) then
        local temp = { }
        repeat
            local id                = query:GetUInt32( 0 )
            local aura_id           = query:GetUInt32( 1 )
            local stack             = query:GetUInt32( 2 )

            if ( not temp[ id ] ) then temp[ id ] = { } end
            local index = #temp[ id ]
            temp[ id ][ index + 1 ] = Aura:new({ aura_id = aura_id, stack = stack })
        until not query:NextRow()

        return temp
    end
end

function Auras:load()
    local auras = self:loadAuras()
    self.simple_condition = self.simple_condition:new(Helper.DATABASE.NAME)
                                :load(Helper.DATABASE.CONDITIONS, Helper.DATABASE.RELATIONS, auras)

    return self
end

return Auras