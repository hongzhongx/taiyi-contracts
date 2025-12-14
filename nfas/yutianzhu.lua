short = { consequence = false }
long = { consequence = false }

deposit_qi = { consequence = true }
withdraw_qi = { consequence = true }
active = { consequence = true }
place_in = { consequence = true }
take_out = { consequence = true }
install = { consequence = true }
uninstall = { consequence = true }

-- 返回一个table
function init_data()
    return {        
        name = "育田珠",
        unit = "颗",
        target = -1, --影响目标实体
        total_qi_conversion = 0,
        conversion_threshold = 10000 --转化的总气量超过这个阈值，则转化目标区域类型为田地
    }
end

function eval_short()
    local nfa_data = nfa_helper:read_contract_data({ name=true })
	return { nfa_data.name }
end

function eval_long()
    local nfa_data = nfa_helper:read_contract_data({ name=true })
	return { "这是一颗" .. nfa_data.name .. "，这个法宝用来生产食物，并能将所在区域转变成农田" }
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

function do_active()
    nfa_helper:enable_tick()
end

function on_heart_beat()
    local nfa_data = nfa_helper:read_contract_data({ total_qi_conversion=true, target=true })

    -- 转化自身的元气到食物
    local nfa = nfa_helper:get_info()
	-- contract_helper:log(string.format('nfa qi=%d', nfa.qi))
    if nfa.qi > 3000 then
        nfa_helper:convert_qi_to_resource(3000, "FOOD")
        -- 记录转化总量
        nfa_data.total_qi_conversion = nfa_data.total_qi_conversion + 3000
        nfa_helper:write_contract_data(nfa_data, { total_qi_conversion=true })
    end

    if contract_helper:is_nfa_valid(nfa.parent) then
        -- 注入资源给父实体
        local resource = contract_helper:get_nfa_resources(nfa.id)
        if resource.food > 0 then
            nfa_helper:inject_material_to(nfa.parent, resource.food, "FOOD", true)
        end        
    end

    -- 尝试转化目标区域类型
    if nfa_data.target ~= -1 and nfa_data.total_qi_conversion >= nfa.data.conversion_threshold then
        local target_nfa = contract_helper:get_nfa_info(nfa_data.target)
        if target_nfa.data.is_zone then
            -- 注意由于改变区域类型的操作需要调用者为心素，因此育田珠的行为要在所有者是个心素的时候才会生效
            local new_type = contract_helper:refine_zone(nfa_data.target)
            contract_helper:narrate(string.format('区域#%d被转化为%s', nfa_data.target, new_type), true)
        end
        -- 完成功能，清除目标
        nfa_data.target = -1
        nfa_helper:write_contract_data(nfa_data, { target=true })
    end
end

function do_place_in(parent)
    -- check parent valid by get_nfa_info
    local parent_nfa = contract_helper:get_nfa_info(parent)
    -- parent_nfa must have same owner as caller account
    nfa_helper:add_to_parent(parent_nfa.id)
end

function do_install(parent)
    -- 先放置
    do_place_in(parent)

    -- 记录安装目标实体并初始化转化记录
    local nfa_data = nfa_helper:read_contract_data({ target=true, total_qi_conversion=true })
    nfa_data.target = parent
    nfa_data.total_qi_conversion = 0;
	nfa_helper:write_contract_data(nfa_data, { target=true, total_qi_conversion=true })
end

function do_take_out()
    nfa_helper:remove_from_parent()
end

function do_uninstall()
    -- 先取出
    do_take_out()
    
    -- 清除安装目标实体
    local nfa_data = nfa_helper:read_contract_data({ target=true })
    nfa_data.target = -1
	nfa_helper:write_contract_data(nfa_data, { target=true })
end