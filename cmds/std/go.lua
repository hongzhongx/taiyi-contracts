function go(dir)
    assert(type(dir) == "string" and dir ~= "", '方向参数无效')

    local nfa_me = nfa_helper:get_info()
    assert(nfa_me.data.is_actor == true, "只有角色才能调用go")

    -- current zone exit
    local actor_me = contract_helper:get_actor_info(nfa_me.id)
    local zone_info = contract_helper:get_zone_info_by_name(actor_me.location)
    local exits = contract_helper:eval_nfa_action(zone_info.nfa_id, "exits", {})
    assert(exits[dir] ~= nil, string.format('往&HIC&%s&NOR&方向不通。', dir))

    -- move to target zone
    local target_zone_name = exits[dir]
    local err = contract_helper:move_actor(actor_me.name, target_zone_name)
    assert(err == '', string.format('%s。', err))

    -- contract_helper:log(string.format('&YEL&%s&NOR&来到了&HIC&%s&NOR&。', me.name, target_zone))
    local look = import_contract("contract.cmds.std.look").look
    look("")
end