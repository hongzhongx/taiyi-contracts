short = { consequence = false }
long = { consequence = false }
exits = { consequence = false }
map = { consequence = false }

unlock = { consequence = true }
lock = { consequence = true }

function init_data()
    return {
        is_zone = true,
        unit = '处',
        locked = true
    }
end

function eval_short()
    return { "练功房大门" }
end

function eval_long()
    local ss = ""
    local nfa_data = nfa_helper:read_contract_data({ locked=true })
    local map_data = import_contract('contract.map.niuxincun.liangongfange.damen').map_data()
    local nfa_me = nfa_helper:get_info()

    -- 首先显示局部地图
    -- 再显示描述
    if nfa_data.locked == true then
        ss = ss .. map_data.map_locked
        ss = ss .. "    这里是牛心村&GRN&练功房&NOR&，大门紧闭。可以等村长李火旺前来或者往西（west）去到村口亭"
    else
        ss = ss .. map_data.map_unlocked
        ss = ss .. "    这里是牛心村&GRN&练功房&NOR&，大门敞开。往北（north）进入练功房，往西（west）去到村口亭"
    end
    return { ss }
end

function eval_exits()
    local nfa_data = nfa_helper:read_contract_data({ locked=true })
    if nfa_data.locked == true then
        return { west = "牛心村.村口亭" }
    else
        return { north = "牛心村.练功房东.内室", west = "牛心村.村口亭" }
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

function do_unlock()
    assert(contract_helper:get_nfa_caller() == 11, "只有李火旺才能开锁")

    local nfa_data = nfa_helper:read_contract_data({ locked=true })
    nfa_data.locked = false
    nfa_helper:write_contract_data(nfa_data, { locked=true })
end

function do_lock()
    assert(contract_helper:get_nfa_caller() == 11, "只有李火旺才能关锁")

    local nfa_data = nfa_helper:read_contract_data({ locked=true })
    nfa_data.locked = true
    nfa_helper:write_contract_data(nfa_data, { locked=true })
end