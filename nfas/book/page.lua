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
    nfa_helper:read_chain({ content=true })
    nfa_data.content = content
	nfa_helper:write_chain({ content=true })

    local nfa = nfa_helper:get_info()
	contract_helper:log(string.format('页面（%d）写入文字：%s', nfa.id, content))

end

function eval_read()
    nfa_helper:read_chain({ content=true })
	contract_helper:log(nfa_data.content)
end