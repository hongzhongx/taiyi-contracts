short = { consequence = false }
long = { consequence = false }
exits = { consequence = false }
map = { consequence = false }

function init_data()
    return {
        is_zone = true,
        unit = '处',
        short = '万魂山',
        long = '往东（east）能到达&HIC&牛心村&NOR&',
        exits = {
            east = "牛心村"
        },
        map = ''
    }
end

function eval_short()
    local nfa_data = nfa_helper:read_contract_data({ short=true })
    return { nfa_data.short }
end

function eval_long()
    -- 首先显示局部地图
    local ss = import_contract('contract.map.wanhunshan.rukou').map_data()

    local nfa_me = nfa_helper:get_info()
    local zone_info = contract_helper:get_zone_info(nfa_me.id)
    local chinese_types = import_contract("contract.utils.types")
    ss = ss .. string.format('    这是一处&HIC&%s&NOR&。', chinese_types.zone_type_strings[zone_info.type_id+1])
    local nfa_data = nfa_helper:read_contract_data({ long=true })
    if nfa_data.long ~= "" then
        return { ss .. nfa_data.long }
    else
        return { ss }
    end
end

function eval_exits()
    local nfa_data = nfa_helper:read_contract_data({ exits=true })
    return nfa_data.exits
end

function eval_map()
    local nfa_data = nfa_helper:read_contract_data({ map=true })
    if nfa_data.map ~= "" then
        return { nfa_data.map }
    else
        return { '暂无地图' }
    end
end

function on_actor_enter(actor_nfa_id)
    local nfa_data = nfa_helper:read_contract_data({ short=true })
    local actor = contract_helper:get_actor_info(actor_nfa_id)
    contract_helper:narrate(string.format('    &YEL&%s&NOR&来到了&HIC&%s&NOR&', actor.name, nfa_data.short), false)
end
