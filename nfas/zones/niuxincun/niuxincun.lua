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

function on_heart_beat()
    contract_helper:log("这里是&HIC&牛心村&NOR&的心跳。")
end

function on_actor_enter(actor_nfa_id)
    -- 如果按后面代码直接再移动到村口亭，那么角色永远无法停留在这里，会自动陷入村口亭
    -- local target_zone = "牛心村.村口亭"
    -- local err = contract_helper:move_actor(actor_data.name, target_zone)
    -- ....
end

function max(a, b)
    return a > b and a or b
end

-- 角色探索回调函数
function on_actor_exploit(actor_nfa_id)
    local nfa_me = nfa_helper:get_info()
    assert(nfa_me.data.is_zone == true, "只有区域才能调用这个入口")

    local resources = contract_helper:get_nfa_materials(nfa_me.id)
    local reward_gold = 0
    local reward_food = 0
    local reward_wood = 0
    local reward_fabric = 0
    local reward_herb = 0
    if resources.gold > 0 then
        reward_gold = max((contract_helper:generate_hash( actor_nfa_id + 7789 )) % resources.gold, resources.gold / 2)
    end
    if resources.food > 0 then
        reward_food = max((contract_helper:generate_hash( actor_nfa_id + 8117 )) % resources.food, resources.food / 2)
    end
    if resources.wood > 0 then
        reward_wood = max((contract_helper:generate_hash( actor_nfa_id + 8681 )) % resources.wood, resources.wood / 2)
    end
    if resources.fabric > 0 then
        reward_fabric = max((contract_helper:generate_hash( actor_nfa_id + 9679 )) % resources.fabric, resources.fabric / 2)
    end
    if resources.herb > 0 then
        reward_herb = max((contract_helper:generate_hash( actor_nfa_id + 10711 )) % resources.herb, resources.herb / 2)
    end

    local tiandao = contract_helper:get_tiandao_property()
    local actor = contract_helper:get_actor_info(actor_nfa_id)

    if reward_gold > 0 then
        nfa_helper:separate_material_out(actor_nfa_id, reward_gold, "GOLD", false)
        contract_helper:log(string.format('&YEL&%d年%d月&NOR&，&YEL&%s&NOR&采集到&YEL&%f&NOR&金石。', tiandao.v_years, tiandao.v_months, actor.name, reward_gold/1000000.0))
    end
    if reward_food > 0 then
        nfa_helper:separate_material_out(actor_nfa_id, reward_food, "FOOD", false)
        contract_helper:log(string.format('&YEL&%d年%d月&NOR&，&YEL&%s&NOR&采集到&YEL&%f&NOR&食物。', tiandao.v_years, tiandao.v_months, actor.name, reward_food/1000000.0))
    end
    if reward_wood > 0 then
        nfa_helper:separate_material_out(actor_nfa_id, reward_wood, "WOOD", false)
        contract_helper:log(string.format('&YEL&%d年%d月&NOR&，&YEL&%s&NOR&采集到&YEL&%f&NOR&木材。', tiandao.v_years, tiandao.v_months, actor.name, reward_wood/1000000.0))
    end
    if reward_fabric > 0 then
        nfa_helper:separate_material_out(actor_nfa_id, reward_fabric, "FABR", false)
        contract_helper:log(string.format('&YEL&%d年%d月&NOR&，&YEL&%s&NOR&采集到&YEL&%f&NOR&织物。', tiandao.v_years, tiandao.v_months, actor.name, reward_fabric/1000000.0))
    end
    if reward_herb > 0 then
        nfa_helper:separate_material_out(actor_nfa_id, reward_herb, "HERB", false)
        contract_helper:log(string.format('&YEL&%d年%d月&NOR&，&YEL&%s&NOR&采集到&YEL&%f&NOR&药材。', tiandao.v_years, tiandao.v_months, actor.name, reward_herb/1000000.0))
    end

end