place_in = { consequence = true }
take_out = { consequence = true }
write = { consequence = true }

read = { consequence = false }

-- 返回一个table
function init_data()
    return {        
        name = "书页",
        unit = "页",
        content = ""
    }
end

function do_write(content)
    local nfa_data = nfa_helper:read_contract_data({ content=true })
    nfa_data.content = content
	nfa_helper:write_contract_data(nfa_data, { content=true })

    local nfa = nfa_helper:get_info()
	contract_helper:log(string.format('页面（%d）写入文字：%s', nfa.id, content))

end

function do_place_in(parent)
    -- check parent valid by get_nfa_info
    local parent_nfa = contract_helper:get_nfa_info(parent)
    -- parent_nfa must have same owner as caller account
    nfa_helper:add_to_parent(parent_nfa.id)
end

function do_take_out()
    nfa_helper:remove_from_parent()
end

function eval_read()
    local nfa_data = nfa_helper:read_contract_data({ content=true })
	contract_helper:log(nfa_data.content)
end