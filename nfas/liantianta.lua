active = { consequence = true }
deposit_qi = { consequence = true }
withdraw_qi = { consequence = true }
withdraw_resources = { consequence = true }

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
    assert(resource.gold > 0, "法宝没有资源")

    assert(contract_base_info.caller == nfa.owner_account, "无权从法宝提取资源")
    nfa_helper:withdraw_to(nfa.owner_account, resource.gold, "GOLD", true)
end

function do_active()
    nfa_helper:enable_tick()
end

function on_heart_beat()
    -- 转化自身的元气到金石    
    local nfa = nfa_helper:get_info()
	-- contract_helper:log(string.format('nfa qi=%d', nfa.qi))
    if nfa.qi > 1000 then
        nfa_helper:convert_qi_to_resource(1000, "GOLD")
    end
end

