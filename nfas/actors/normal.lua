welcome = { consequence = false }
look = { consequence = false }

go = { consequence = true }
heart_beat = { consequence = true }

function init_data()
    return {
        is_actor = true,
        unit = '个'
    }
end

function eval_welcome()
    import_contract('contract.welcome').welcome();
end

function eval_look(params)
    local look = import_contract("contract.cmds.std.look").look
    look(#params == 0 and "" or params[1])
end

function do_go()
    local nfa = nfa_helper:get_info()
    contract_helper:log(string.format('&YEL&%s&NOR&不会走路。', contract_helper:get_actor_info(nfa.id).name))
end

function do_heart_beat()
    chainhelper:log(string.format("这里是&YEL&%s&NOR&的心跳。", actor_helper:get_info().name))
end
