heart_beat = { consequence = true }
active = { consequence = true }
place_in = { consequence = true }
take_out = { consequence = true }
setup = { consequence = true }
deposit_qi = { consequence = true }
withdraw_qi = { consequence = true }

-- 接界符，一次性法宝，单向连接区域A到区域B
-- 返回一个table
function init_data()
    return {        
        name = "接界符",
        unit = "张",
        from_zone = -1, --目标区域A的NFA ID
        to_zone = -1, --目标区域B的NFA ID
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

    nfa_helper:withdraw_to(nfa.owner_account, amount, "QI", true)
end

function do_active()
    nfa_helper:enable_tick()
end

function do_heart_beat()
    local nfa = nfa_helper:get_info()
    assert(nfa.qi >= nfa.data.action_qi_threshold, "真气不足，无法运转")

    nfa_helper:read_chain({ from_zone=true, to_zone=true })
    assert(nfa_data.from_zone ~= 1 and nfa_data.to_zone ~= 1, "符箓无效，连接区域没有设置好")

    local nfa_a = contract_helper:get_nfa_info(nfa_data.from_zone)
    assert(nfa_a.data.is_zone, "起点不是一个区域")

    local nfa_b = contract_helper:get_nfa_info(nfa_data.to_zone)
    assert(nfa_b.data.is_zone, "终点不是一个区域")

    contract_helper:connect_zones(nfa_data.from_zone, nfa_data.to_zone)
    contract_helper:log(string.format('%s可以通向%s了', contract_helper:get_zone_info(nfa_data.from_zone).name, contract_helper:get_zone_info(nfa_data.to_zone).name))

    -- 完成功能，清除目标
    nfa_data.from_zone = -1
    nfa_data.to_zone = -1
    nfa_helper:write_chain({ from_zone=true, to_zone=true })

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

function do_setup(from_zone_name, to_zone_name)
    local from = contract_helper:get_zone_info_by_name(from_zone_name)
    local to = contract_helper:get_zone_info_by_name(to_zone_name)

    -- 记录安装目标实体
    nfa_helper:read_chain({ from_zone=true, to_zone=true })
    nfa_data.from_zone = from.nfa_id
    nfa_data.to_zone = to.nfa_id
	nfa_helper:write_chain({ from_zone=true, to_zone=true })
end

