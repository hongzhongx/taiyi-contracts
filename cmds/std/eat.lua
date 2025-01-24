function eat(something)
    assert(type(something) == "string", '食用参数无效')
    if something == "" then
        something = "food" -- 默认吃点食物
    end

    local nfa_me = nfa_helper:get_info()
    assert(nfa_me.data.is_actor == true, "只有角色才能调用eat")
    local actor_me = contract_helper:get_actor_info(nfa_me.id)

    if string.lower(something) == "food" then
        local nfa_data = nfa_helper:read_contract_data({ eat_start_block=true, eat_count=true })
        nfa_data.eat_start_block = nfa_data.eat_start_block or contract_helper:block() -- 可能的初始化
        nfa_data.eat_count = nfa_data.eat_count or 0

        local tiandao = contract_helper:get_tiandao_property()
        if (contract_helper:block() - nfa_data.eat_start_block) >= tiandao.v_1day_blocks then
            nfa_data.eat_count = 0
            nfa_data.eat_start_block = contract_helper:block()
        end

        assert(nfa_data.eat_count < 3, "今天进食食物已经超过三次了")

        local f = nfa_helper:get_resources().food
        if f > 100 then
            f = 100
        end
        assert(f > 0, "没有食物了")
        local old_qi = nfa_me.qi
        nfa_helper:convert_resource_to_qi(f, "FOOD")
        local cur_qi = nfa_helper:get_info().qi
        contract_helper:narrate(string.format('&YEL&%s&NOR&吃了一些食物，体内真气增加了&YEL&%d&NOR&', actor_me.name, cur_qi-old_qi), false)

        nfa_data.eat_count = nfa_data.eat_count + 1
        nfa_helper:write_contract_data(nfa_data, { eat_start_block=true, eat_count=true })

    else
        assert(false, "吃不了这个，目前只能吃食物（food）")
    end
end