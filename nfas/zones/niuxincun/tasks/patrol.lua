function isInArray(value, array)
    for _, v in ipairs(array) do
        if v == value then
            return true
        end
    end
    return false
end

function tick()
    local nfa_me = nfa_helper:get_info()
    assert(nfa_me.data.is_actor == true, "只有角色才能调用该任务")

    local nfa_data = nfa_helper:read_contract_data({ last_go_block=true, patrol_dir=true })
    nfa_data.patrol_dir = nfa_data.patrol_dir or 1
    if nfa_data.last_go_block == nil then
        nfa_data.last_go_block = contract_helper:block() -- 可能的初始化
        nfa_helper:write_contract_data(nfa_data, { last_go_block=true })
    end

    if (contract_helper:block() - nfa_data.last_go_block) < 20 then -- 大约每1分钟
        return
    end

    -- current zone
    local actor_me = contract_helper:get_actor_info(nfa_me.id)
    local zone_info = contract_helper:get_zone_info_by_name(actor_me.location)

    local path_point = { "牛心村.村口亭", "牛心村.练功房东.大门", "牛心村.练功房东.内室" }

    local target_i = 0
    for i, v in ipairs(path_point) do
        if v == zone_info.name then
            if nfa_data.patrol_dir == 1 then
                target_i = i + 1
                if i == #path_point then
                    target_i = i - 1
                    nfa_data.patrol_dir = -1
                end
            else
                target_i = i - 1
                if i == 1 then
                    target_i = i + 1
                    nfa_data.patrol_dir = 1
                end
            end

            -- 只针对李火旺的逻辑
            if nfa_me.id == 11 and zone_info.name == "牛心村.练功房东.大门" then
                if nfa_data.patrol_dir == 1 then
                    -- open door
                    nfa_helper:do_nfa_action(zone_info.nfa_id, 'unlock', {})
                    contract_helper:narrate(string.format('&YEL&%s&NOR&打开了&HIC&练功房大门&NOR&。', actor_me.name), true)
                elseif nfa_data.patrol_dir == -1 then
                    -- close door
                    nfa_helper:do_nfa_action(zone_info.nfa_id, 'lock', {})
                    contract_helper:narrate(string.format('&YEL&%s&NOR&关闭了&HIC&练功房大门&NOR&。', actor_me.name), true)
                end
            end

            -- move to target zone
            local target_zone_name = path_point[target_i]
            local err = contract_helper:move_actor(actor_me.name, target_zone_name)
            assert(err == '', string.format('%s。', err))
            break
        end
    end

    if target_i == 0 then
        contract_helper:narrate(string.format('&YEL&%s&NOR&不在岗位上，无法巡逻。', actor_me.name), false)
    end

    nfa_data.last_go_block = contract_helper:block()
    nfa_helper:write_contract_data(nfa_data, { last_go_block=true, patrol_dir=true })
end