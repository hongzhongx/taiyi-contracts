short = { consequence = false }
long = { consequence = false }
exits = { consequence = false }
map = { consequence = false }

function init_data()
    return {
        is_zone = true,
        unit = '处'
    }
end

function eval_short()
    return { "村口亭" }
end

function eval_long()
    -- 首先显示局部地图
    local ss = import_contract('contract.map.niuxincun.cunkouting').map_data()

    local nfa_me = nfa_helper:get_info()
    local zone_info = contract_helper:get_zone_info(nfa_me.id)
    local chinese_types = import_contract("contract.utils.types")
    ss = ss .. string.format('    这是一处&HIC&%s&NOR&。', chinese_types.zone_type_strings[zone_info.type_id+1])
    ss = ss .. '往南（south）是出村，往北（north)是进入村中小道，往西(west)是去往&HIC&练功房&NOR&，往东(east)是去往另一处&HIC&练功房&NOR&'
    return { ss }
end

function eval_exits()
    local exits = {
        south = "牛心村",
        north = "牛心村.村道",
        west = "牛心村.练功房西.大门",
        east = "牛心村.练功房东.大门"
    }
    return exits
end

function eval_map()
    local map_data = import_contract('contract.map.niuxincun').map_data()
    return { map_data }
end

function on_actor_enter(actor_nfa_id)
    local actor = contract_helper:get_actor_info(actor_nfa_id)
    contract_helper:narrate(string.format('    &YEL&%s&NOR&来到了&HIC&%s&NOR&', actor.name, eval_short()[1]), false)
end
