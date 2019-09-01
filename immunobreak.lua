_addon.name = 'immunobreak'
_addon.version = '0.0.0.1'
_addon.author = 'yyoshisaur'
_addon.command = 'immunobreak'

res = require('resources')

local immunobreak_message_id = S{653, 654}
local success_message_id = S{236, 237, 268, 271}
local expired_message_id = S{64, 204, 206, 350, 531}
local died_message_id = S{6,20,113,406,605,646}

local mobs = {}

windower.register_event('action', function(act)

    if immunobreak_message_id:contains(act.targets[1].actions[1].message) then
        local target = act.targets[1].id
        local effect = act.targets[1].actions[1].param
        local spell = act.param
        local actor = act.actor_id

        local mob_info = windower.ffxi.get_mob_by_id(target)

        if not mobs[target] then
            mobs[target] = {}
        end

        if mobs[target] and mobs[target][effect] then
            mobs[target][effect] = mobs[target][effect] + 1
        else
            mobs[target][effect] = 1 
        end
        local spell_name = res.spells[spell].en
        windower.add_to_chat(123, 'Immunobreak: '..spell_name..' ('..  mobs[target][effect]..') ---> '..mob_info.name)
    elseif success_message_id:contains(act.targets[1].actions[1].message) then
        local target = act.targets[1].id
        local effect = act.targets[1].actions[1].param
        local spell = act.param
        local actor = act.actor_id

        if mobs[target] and mobs[target][effect] then
            mobs[target][effect] = nil
        end
    end
end)

windower.register_event('zone change', function()
    mobs = {}
end)

windower.register_event('logout', function()
    mobs = {}
end)