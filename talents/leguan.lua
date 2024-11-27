-- 返回一个table
function talent_data()
    return {
        name = "乐观",
        description = "快乐+5"
    }
end

-- actor_helper is valid
function trigger()
    actor_helper:modify_attributes({ SPR = 5 })
end
