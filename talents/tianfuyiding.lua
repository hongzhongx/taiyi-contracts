-- 返回一个table
function talent_data()
    return {
        name = "天赋异禀",
        description = "初始可用属性点+20",
        init_attribute_amount_modifier = 20
    }
end

-- actor_helper is valid
function trigger()
    -- no effect
end
