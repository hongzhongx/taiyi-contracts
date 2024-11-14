set_page = { consequence = true }
read = { consequence = false }

-- 返回一个table
function init_data()
    return {        
        name = "书",
        unit = "本"
    }
end

function do_set_page(me, params)
    assert(#params == 2, '参数数目不匹配')
    local page_id = params[1]
    local page_nfa_id = params[2]
    local check_page = contract_helper:get_nfa_info(page_nfa_id)
    assert(check_page.symbol == 'nfa.jingshu.page', '加入的对象不是书页')

    local nfa = nfa_helper:get_info()
    local data = nfa.data
    local pages = data.pages or {}
    pages[page_id] = page_nfa_id
    data.pages = pages;
    nfa_helper:set_data(data)

    nfa_helper:add_child(page_nfa_id)

	contract_helper:log(string.format('设置书页（%d）为本书第%d页', page_nfa_id, page_id))
end

function do_read(me, params)
    assert(#params == 1, '参数数目不匹配')
    local page_id = params[1]
    local nfa = nfa_helper:get_info()
    local pages = nfa.data.pages or {}
    local page_nfa_id = pages[page_id]

    if page_nfa_id ~= nil then
        contract_helper:eval_nfa_action(page_nfa_id, "read", {})
    else
        contract_helper:log(string.format('这本书没有第%d页', page_id))
    end
end