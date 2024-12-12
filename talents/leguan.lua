-- 返回一个table
function talent_data()
    return {
        name = "乐观",
        description = "快乐+5"
    }
end

-- actor_helper is valid
function trigger()
    local nfa_me = nfa_helper:get_info()
    local actor = contract_helper:get_actor_info(nfa_me.id)

    nfa_helper:modify_actor_attributes({ mood = 5 })

    contract_helper:log(string.format('由于&YEL&乐观&NOR&天赋激发，%s的&HIC&快乐&NOR&上限增加了。', actor.name))
    return { triggered = true }
end
