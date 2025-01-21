-- 从nfa的角度看进来
function look(target_name)
    local nfa_me = nfa_helper:get_info()
    if target_name == "" then
        if nfa_me.data.is_actor then
            local actor_me = contract_helper:get_actor_info(nfa_me.id)
            local zone_info = contract_helper:get_zone_info_by_name(actor_me.location)
            Zone = import_contract("contract.inherit.zone").Zone
            local zone = Zone:new(zone_info)

            contract_helper:narrate(string.format("    这里是&HIC&%s&NOR&。", zone:short()), false)
            contract_helper:narrate(string.format("    %s。", zone:long()), false)

            local actors = contract_helper:list_actors_on_zone(zone_info.nfa_id)
            if #actors > 1 then
                contract_helper:narrate('    这里还有其他人：', false)
            end
            for i, actor in pairs(actors) do
                if actor.name ~= actor_me.name then
                    contract_helper:narrate(string.format('        普通百姓&YEL&%s&NOR&', actor.name), false)
                end
            end
        else
            contract_helper:narrate('什么都看不了', false)
        end
    else
        if nfa_me.data.is_actor then
            local actor = contract_helper:get_actor_info(nfa_me.id)
            contract_helper:narrate(string.format('&YEL&%s&NOR&看了一眼&YEL&%s&NOR&', actor.name, target_name), false)
        else
            contract_helper:narrate('什么都看不了', false)
        end
    end
end