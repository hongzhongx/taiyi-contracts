short = { consequence = false }
long = { consequence = false }
exits = { consequence = false }
map = { consequence = false }

heart_beat = { consequence = true }

function init_data()
    return {
        is_zone = true,
        unit = '处'
    }
end

function eval_short()
    return { "牛心村" }
end

function eval_long()
    return { "往南（south）是去往&HIC&大梁城&NOR&，往北（north）就进村" }
end

function eval_exits()
    return {
        south = "大梁",
        north = "牛心村.村口亭"
    }
end

function eval_map()
    local map = import_contract('contract.map.niuxincun')
    return { map.map_data() }
end

function do_heart_beat()
    contract_helper:log("这里是&HIC&牛心村&NOR&的心跳。")
end

function on_actor_enter(actor_nfa_id)
    -- 如果按后面代码直接再移动到村口亭，那么角色永远无法停留在这里，会自动陷入村口亭
    -- local target_zone = "牛心村.村口亭"
    -- local err = contract_helper:move_actor(actor_data.name, target_zone)
    -- ....
end
