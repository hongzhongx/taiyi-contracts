function start()
    local nfa_me = nfa_helper:get_info()
    assert(nfa_me.data.is_actor == true, "只有角色才能调用")
    local actor_me = contract_helper:get_actor_info(nfa_me.id)

    contract_helper:narrate(string.format('&YEL&%s&NOR&准备修真。', actor_me.name), true)
    local cultivation_id = contract_helper:create_cultivation(nfa_me.id, {nfa_me.id}, {10000}, 300)

    local err = contract_helper:participate_cultivation(cultivation_id, nfa_me.id, nfa_me.qi)
    assert(err == '', string.format('%s。', err))

    local old_qi = nfa_me.qi;
    local err = contract_helper:start_cultivation(cultivation_id)
    assert(err == '', string.format('%s。', err))

    -- 记录修真序号和修真前真气
    local nfa_data = nfa_helper:read_contract_data({ cultivation=true, qi_before_cultivation=true })
    nfa_data.cultivation = cultivation_id
    nfa_data.qi_before_cultivation = old_qi
	nfa_helper:write_contract_data(nfa_data, { cultivation=true, qi_before_cultivation=true })

    contract_helper:narrate(string.format('&YEL&%s&NOR&开始了修真（%d）。', actor_me.name, cultivation_id), true)
end

function stop()
    local nfa_me = nfa_helper:get_info()
    assert(nfa_me.data.is_actor == true, "只有角色才能调用")
    local actor_me = contract_helper:get_actor_info(nfa_me.id)

    -- 读取修真序号
    local nfa_data = nfa_helper:read_contract_data({ cultivation=true, qi_before_cultivation=true })
    assert(nfa_data.cultivation ~= nil and type(nfa_data.cultivation) == "number" and nfa_data.cultivation ~= -1, "没有找到修真活动")

    local err = contract_helper:stop_and_close_cultivation(nfa_data.cultivation)
    assert(err == '', string.format('%s。', err))

    -- 更新nfa数据
    nfa_me = nfa_helper:get_info()
    contract_helper:narrate(string.format('&YEL&%s&NOR&获得了&BLU&%d&NOR&先天真炁。', actor_me.name, nfa_me.qi - nfa_data.qi_before_cultivation), true)
    contract_helper:narrate(string.format('&YEL&%s&NOR&结束了修真（%d）。', actor_me.name, nfa_data.cultivation), true)

    -- 清除修真序号
    nfa_data.cultivation = -1
    nfa_helper:write_contract_data(nfa_data, { cultivation=true })
end