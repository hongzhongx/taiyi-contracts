-- 从nfa的角度看进来
function look(target_name)
    local nfa_me = nfa_helper:get_info()
    if target_name == "" then
        if nfa_me.data.is_actor then
            local actor_me = contract_helper:get_actor_info(nfa_me.id)
            local zone_info = contract_helper:get_zone_info_by_name(actor_me.location)
            Zone = import_contract("contract.inherit.zone").Zone
            local zone = Zone:new(zone_info)

            contract_helper:log(string.format("    这里是&HIC&%s&NOR&。", zone:short()))
            contract_helper:log(string.format("    %s。", zone:long()))

            local actors = contract_helper:list_actors_on_zone(zone_info.nfa_id)
            if #actors > 1 then
                contract_helper:log('    这里还有其他人：')
            end
            for i, actor in pairs(actors) do
                if actor.name ~= actor_me.name then
                    contract_helper:log(string.format('        普通百姓&YEL&%s&NOR&', actor.name))
                end
            end
        else
            contract_helper:log('什么都看不了')
        end
    else
        if nfa_me.data.is_actor then
            local actor = contract_helper:get_actor_info(nfa_me.id)
            contract_helper:log(string.format('&YEL&%s&NOR&看了一眼&YEL&%s&NOR&', actor.name, target_name))
        else
            contract_helper:log('什么都看不了')
        end
    end
end