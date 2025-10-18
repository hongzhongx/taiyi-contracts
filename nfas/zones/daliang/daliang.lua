short = { consequence = false }
long = { consequence = false }
exits = { consequence = false }
map = { consequence = false }

set_contract_permission = { consequence = true }
remove_contract_permission = { consequence = true }

function init_data()
    return {
        is_zone = true,
        unit = '处'
    }
end

function eval_short()
    return { "大梁" }
end

function eval_long()
    return { "往西(west)是去往&HIC&青丘&NOR&，往北（north）是去往&HIC&牛心村&NOR&" }
end

function eval_exits()
    return {
        west = "青丘",
        north = "牛心村"
    }
end

function eval_map()
    return { "" }
end

function on_heart_beat()
    contract_helper:narrate("这里是&HIC&大梁城&NOR&的心跳。", false)
end

-- 仅由move_actor回调
function on_actor_enter(actor_nfa_id)
    contract_helper:narrate("    这里是&HIC&大梁&NOR&城门。这位朋友，本司看你筋骨不凡，就送你一本&HIM&路引&NOR&。", false)
    local nft_id = contract_helper:create_nfa(actor_nfa_id, "nfa.item.luyin", { referee = "监天司", destination = "后蜀"}, true)
    Item = import_contract('contract.inherit.item').Item 
    local luyin = Item:new(contract_helper:get_nfa_info(nft_id))

    local actor = contract_helper:get_actor_info(actor_nfa_id)
    contract_helper:narrate(string.format('    %s收到&YEL&%s&NOR&颁发的%s，可以去到&HIC&%s&NOR&', actor.name, luyin:data().referee, luyin:short(), luyin:data().destination), false)
end

function do_set_contract_permission(contract_name, permission)
    local nfa = nfa_helper:get_info()
    local zone_info = contract_helper:get_zone_info(nfa.id)

    contract_helper:set_zone_contract_permission(zone_info.name, contract_name, permission == 1 and true or false)
end

function do_remove_contract_permission(contract_name)
    local nfa = nfa_helper:get_info()
    local zone_info = contract_helper:get_zone_info(nfa.id)

    contract_helper:remove_zone_contract_permission(zone_info.name, contract_name)
end