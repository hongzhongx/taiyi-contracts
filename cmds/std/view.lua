-- 从nfa的角度看到的景象
function view(target_name)
    local nfa_me = nfa_helper:get_info()
    if target_name == "" then
        if nfa_me.data.is_actor then
            local actor_me = contract_helper:get_actor_info(nfa_me.id)
            local zone_info = contract_helper:get_zone_info_by_name(actor_me.location)
            Zone = import_contract("contract.inherit.zone").Zone
            local zone = Zone:new(zone_info)

            contract_helper:narrate(string.format("%s", zone:view()), false)
        else
            contract_helper:narrate('', false)
        end
    else
        if nfa_me.data.is_actor then
            local actor = contract_helper:get_actor_info(nfa_me.id)
            local inv = contract_helper:list_nfa_inventory(nfa_me.id, "")
            if #inv == 0 then
                contract_helper:narrate(string.format('    &YEL&%s&NOR&没有&YEL&%s&NOR&', actor.name, target_name), false)
            else
                Item = import_contract('contract.inherit.item').Item
                for i, obj in pairs(inv) do
                    local item = Item:new(obj)
                    local short_name = item:short()
                    if target_name == short_name then
                        contract_helper:narrate(string.format("%s", item:view()), false)
                        break
                    end
                end
            end
        else
            contract_helper:narrate('', false)
        end
    end
end