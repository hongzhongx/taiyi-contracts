-- 返回一个table
function talent_data()
    return {
        name = "天赋异禀",
        description = "初始可用属性点+20",
        init_attribute_amount_modifier = 20
    }
end

-- nfa_helper is valid
-- 不需要触发的天赋，就不要定义trigger函数
--function trigger() end
