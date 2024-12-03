heart_beat = { consequence = true }
active = { consequence = true }
place_in = { consequence = true }
take_out = { consequence = true }
setup = { consequence = true }
deposit_qi = { consequence = true }
withdraw_qi = { consequence = true }

-- 太虚符，一次性法宝，升级区域天道
-- 返回一个table
function init_data()
    return {        
        name = "太虚符",
        unit = "张",
        target_zone = -1, --目标区域的NFA
        contract_name = "", --升级的目标合约名称
        action_qi_threshold = 1000000 --内含真气超过这个阈值才能行使功能
    }
end

function do_deposit_qi(amount)
    assert(amount > 0, "设置的真气无效")
    nfa_helper:deposit_from(contract_base_info.caller, amount, "QI", true)
end

function do_withdraw_qi(amount)
    assert(amount > 0, "设置的真气无效")

    local nfa = nfa_helper:get_info()
    assert(nfa.qi < amount, "法宝内真气不足")

    assert(contract_base_info.caller == nfa.owner_account, "无权从法宝提取真气")
    nfa_helper:withdraw_to(nfa.owner_account, amount, "QI", true)
end

function do_active()
    nfa_helper:enable_tick()
end

function do_heart_beat()
    local nfa = nfa_helper:get_info()
    assert(nfa.qi >= nfa.data.action_qi_threshold, "真气不足，无法运转")
    assert(contract_helper:is_nfa_valid(nfa.parent) == false, "一次性法宝使用时不能放置在其他地方")

    nfa_helper:read_chain({ target_zone=true, contract_name=true })
    assert(nfa_data.target_zone ~= -1 and nfa_data.contract_name ~= "", "符箓无效，区域或者天道合约名称没有设置好")
    assert(contract_helper:is_nfa_valid(nfa_data.target_zone), "法宝未设置有效区域")

    local nfa = contract_helper:get_nfa_info(nfa_data.target_zone)
    assert(nfa.data.is_zone, "目标不是一个区域")
    local zone = contract_helper:get_zone_info(nfa.id)

    -- 区域nfa的symbol不会改变，仅仅改变nfa的主合约
    contract_helper:change_nfa_contract(nfa.id, nfa_data.contract_name)
    contract_helper:log(string.format('整个"%s"发生了一些变化', zone.name))

    -- 完成功能，清除目标
    nfa_data.target_zone = -1
    nfa_data.contract_name = ""
    nfa_helper:write_chain({ target_zone=true, contract_name=true })

    -- 将真气归还给法宝创建者
    nfa_helper:withdraw_to(nfa.creator_account, nfa.qi, "QI", true)

    -- 一次性法宝，标记销毁
    nfa_helper:destroy()
end

function do_place_in(parent)
    -- check parent valid by get_nfa_info
    local parent_nfa = contract_helper:get_nfa_info(parent)
    -- parent_nfa must have same owner as caller account
    nfa_helper:add_to_parent(parent_nfa.id)
end

function do_take_out()
    nfa_helper:remove_from_parent()
end

function do_setup(target_zone_name, contract_name)
    assert(contract_name ~= "", "合约名称为空")
    local zone = contract_helper:get_zone_info_by_name(target_zone_name)

    -- 记录安装目标实体
    nfa_helper:read_chain({ target_zone=true, contract_name=true })
    nfa_data.target_zone = zone.nfa_id
    nfa_data.contract_name = contract_name
	nfa_helper:write_chain({ target_zone=true, contract_name=true })
end

