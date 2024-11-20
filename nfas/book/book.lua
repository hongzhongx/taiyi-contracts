set_page = { consequence = true }
set_title = { consequence = true }
read = { consequence = false }

-- 返回一个table
function init_data()
    return {        
        name = "书",
        unit = "本"
    }
end

function do_set_title(title)
    assert(title ~= '', '设置书名为空')

    nfa_helper:read_chain({ name=true })
    nfa_data.name = title
	nfa_helper:write_chain({ name=true })
end

function do_set_page(page_id, page_nfa_id)
    local check_page = contract_helper:get_nfa_info(page_nfa_id)
    assert(check_page.symbol == 'nfa.jingshu.page', '加入的对象不是书页')

    nfa_helper:read_chain({ pages=true })
    nfa_data.pages = nfa_data.pages or {} -- 由于nfa数据中本来没有pages字段，所以需要可能的初始化
    nfa_data.pages[page_id] = page_nfa_id
	nfa_helper:write_chain({ pages=true })

    nfa_helper:add_child(page_nfa_id)

	contract_helper:log(string.format('设置书页（%d）为本书第%d页', page_nfa_id, page_id))
end

-- page_id=0 表示获取书名，page_id > 0表示从第一页开始读第几页
function do_read(page_id)
    if page_id == 0 then
        nfa_helper:read_chain({ name=true })
        contract_helper:log(nfa_data.name)
    else
        nfa_helper:read_chain({ pages=true })
        local pages = nfa_data.pages or {}
        local page_nfa_id = pages[page_id]

        if page_nfa_id ~= nil then
            contract_helper:eval_nfa_action(page_nfa_id, "read", {})
        else
            contract_helper:log(string.format('这本书没有第%d页', page_id))
        end
    end
end