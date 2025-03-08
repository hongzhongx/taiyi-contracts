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
    return { "练功房内室" }
end

function eval_long()
    local ss = ""
    -- 首先显示局部地图
    local map_data = import_contract('contract.map.niuxincun.liangongfange.neishi').map_data()
    ss = ss .. map_data
    -- 再显示描述
    ss = ss .. "    这里是&GRN&练功房内室&NOR&。往南（south）走到大门"
    return { ss }
end

function eval_exits()
    return { south = "牛心村.练功房东.大门" }
end

function eval_map()
    local map_data = import_contract('contract.map.niuxincun').map_data()
    return { map_data }
end

function on_actor_enter(actor_nfa_id)
    local actor = contract_helper:get_actor_info(actor_nfa_id)
    contract_helper:narrate(string.format('    &YEL&%s&NOR&来到了&HIC&%s&NOR&。', actor.name, eval_short()[1]), false)
end
