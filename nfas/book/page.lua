write = { consequence = true }
read = { consequence = false }

-- 返回一个table
function init_data()
    return {        
        name = "书页",
        unit = "页"
    }
end

function do_write(me, params)
    assert(#params == 1, '参数数目不匹配')
    local content = params[1]

    local nfa = nfa_helper:get_info()
    local data = nfa.data
    data.content = content
    nfa_helper:set_data(data)

	contract_helper:log(string.format('页面（%d）写入文字：%s', nfa.id, nfa_helper:get_info().data.content))

end

function do_read(me, params)
	contract_helper:log(nfa_helper:get_info().data.content)
end