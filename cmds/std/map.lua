function map(target)
    local map_str = ""
    local nfa_me = nfa_helper:get_info()
    if target == "" then
        if nfa_me.data.is_actor then
            local actor_me = contract_helper:get_actor_info(nfa_me.id)
            local zone_info = contract_helper:get_zone_info_by_name(actor_me.location)
            local result = contract_helper:eval_nfa_action(zone_info.nfa_id, "map", {})
            map_str = (#result == 1 and result[1] or "")
        elseif nfa_me.data.is_zone then
            local result = contract_helper:eval_nfa_action(nfa_me.id, "map", {})
            map_str = (#result == 1 and result[1] or "")        
        end
    elseif type(target) == "string" then
        if contract_helper:is_zone_valid_by_name(target) then
            local zone_info = contract_helper:get_zone_info_by_name(target)
            local result = contract_helper:eval_nfa_action(zone_info.nfa_id, "map", {})
            map_str = (#result == 1 and result[1] or "")
        end
    end

    contract_helper:narrate(map_str, false)
end