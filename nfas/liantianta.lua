active = { consequence = true }
deposit_qi = { consequence = true }
withdraw_qi = { consequence = true }
withdraw_resources = { consequence = true }
inject_material_to_nfa = { consequence = true }

-- 返回一个table
function init_data()
    return {        
        name = "炼天塔",
        unit = "座"
    }
end

function do_deposit_qi(amount)
    assert(amount > 0, "设置的真气无效")
    nfa_helper:deposit_from(contract_base_info.caller, amount, "QI", true)
end

function do_withdraw_qi(amount)
    assert(amount > 0, "设置的真气无效")

    local nfa = nfa_helper:get_info()
    assert(nfa.qi >= amount, "法宝内真气不足")

    assert(contract_base_info.caller == nfa.owner_account, "无权从法宝提取真气")
    nfa_helper:withdraw_to(nfa.owner_account, amount, "QI", true)
end

function do_withdraw_resources()
    local nfa = nfa_helper:get_info()
    local resource = contract_helper:get_nfa_resources(nfa.id)

    assert(contract_base_info.caller == nfa.owner_account, "无权从法宝提取资源")

    if resource.gold > 0 then
        nfa_helper:withdraw_to(nfa.owner_account, resource.gold, "GOLD", true)
    end
    if resource.food > 0 then
        nfa_helper:withdraw_to(nfa.owner_account, resource.food, "FOOD", true)
    end
    if resource.wood > 0 then
        nfa_helper:withdraw_to(nfa.owner_account, resource.wood, "WOOD", true)
    end
    if resource.fabric > 0 then
        nfa_helper:withdraw_to(nfa.owner_account, resource.fabric, "FABR", true)
    end
    if resource.herb > 0 then
        nfa_helper:withdraw_to(nfa.owner_account, resource.herb, "HERB", true)
    end    
end

function do_inject_material_to_nfa(nfa_id, amount, material)
    assert(amount > 0, "设置的资源无效")
    assert(material == "GOLD" or material == "FOOD" or material == "WOOD" or material == "FABR" or material == "HERB", "设置的资源类型无效")

    local nfa = nfa_helper:get_info()
    assert(contract_base_info.caller == nfa.owner_account or contract_base_info.caller == nfa.active_account, "无权从法宝提取资源")

    assert(contract_helper:is_nfa_valid(nfa_id), "目标法宝无效")
    local target_nfa = contract_helper:get_nfa_info(nfa_id)
    assert(contract_base_info.caller == target_nfa.owner_account or contract_base_info.caller == target_nfa.active_account, "只能向自己拥有或者操作的法宝注入资源")

    nfa_helper:inject_material_to(nfa_id, amount, material, true)
end

function do_active()
    nfa_helper:enable_tick()
end

function on_heart_beat()
    -- 转化自身的元气到五种物质
    local nfa = nfa_helper:get_info()
	-- contract_helper:log(string.format('nfa qi=%d', nfa.qi))
    if nfa.qi > 10000000 then
        nfa_helper:convert_qi_to_resource(10000000, "GOLD")
    end
    if nfa.qi > 6000000 then
        nfa_helper:convert_qi_to_resource(6000000, "FOOD")
    end
    if nfa.qi > 4000000 then
        nfa_helper:convert_qi_to_resource(4000000, "WOOD")
    end
    if nfa.qi > 6000000 then
        nfa_helper:convert_qi_to_resource(6000000, "FABR")
    end
    if nfa.qi > 8000000 then
        nfa_helper:convert_qi_to_resource(8000000, "HERB")
    end
end

