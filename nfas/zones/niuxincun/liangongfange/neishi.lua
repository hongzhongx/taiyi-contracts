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
    local damen_zone_info = contract_helper:get_zone_info_by_name("牛心村.练功房东.大门")
    local nfa_data = contract_helper:read_nfa_contract_data(damen_zone_info.nfa_id, { locked=true })
    local map_data = import_contract('contract.map.niuxincun.liangongfange.neishi').map_data()

    -- 首先显示局部地图
    -- 再显示描述
    if nfa_data.locked == true then
        ss = ss .. map_data.map_locked
        ss = ss .. "    这里是&GRN&练功房内室&NOR&，大门已锁，你只有等村长&HIC&李火旺&NOR&前来才能出去"
    else
        ss = ss .. map_data.map_unlocked
        ss = ss .. "    这里是&GRN&练功房内室&NOR&。往南（south）走到大门"
    end
    return { ss }
end

function eval_exits()
    local damen_zone_info = contract_helper:get_zone_info_by_name("牛心村.练功房东.大门")
    local nfa_data = contract_helper:read_nfa_contract_data(damen_zone_info.nfa_id, { locked=true })
    if nfa_data.locked == true then
        return {}
    else
        return { south = "牛心村.练功房东.大门" }
    end
end

function eval_map()
    local map_data = import_contract('contract.map.niuxincun').map_data()
    return { map_data }
end

function on_actor_enter(actor_nfa_id)
    local actor = contract_helper:get_actor_info(actor_nfa_id)
    contract_helper:narrate(string.format('    &YEL&%s&NOR&来到了&HIC&%s&NOR&。', actor.name, eval_short()[1]), false)
end
