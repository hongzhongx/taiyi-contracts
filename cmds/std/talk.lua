function talk(someone, something)
    assert(type(someone) == "string", '谈话对象参数无效')
    assert(type(something) == "string", '谈话内容参数无效')
    assert(something ~= "", "总得说点什么吧")

    local nfa_me = nfa_helper:get_info()
    assert(nfa_me.data.is_actor == true, "只有角色才能调用talk")
    assert(someone ~= "", "你得指定和谁谈话")
    assert(contract_helper:is_actor_valid_by_name(someone), "找不到谈话目标")

    nfa_helper:talk_to_actor(someone, something)
end
