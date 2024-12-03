welcome = { consequence = false }
look = { consequence = false }
inventory = { consequence = false }
hp = { consequence = false }
resource = { consequence = false }
map = { consequence = false }

go = { consequence = true }
heart_beat = { consequence = true }
deposit_qi = { consequence = true }
withdraw_qi = { consequence = true }

function init_data()
    return {
        is_actor = true,
        unit = '个'
    }
end

function eval_welcome()
    import_contract('contract.welcome').welcome();
end

function eval_look(target)
    local look = import_contract("contract.cmds.std.look").look
    look(target)
end

function eval_inventory(target)
    local inventory = import_contract("contract.cmds.actor.inventory").inventory
    inventory(target)
end

function eval_hp(target, option)
    local hp = import_contract("contract.cmds.actor.hpcmd").hp
    hp(target, option)
end

function eval_resource(target)
    local resource = import_contract("contract.cmds.actor.resource").resource
    resource(target)
end

function eval_map(target)
    local map = import_contract("contract.cmds.std.map").map
    map(target)
end

function do_go(dir)
    local go = import_contract("contract.cmds.std.gocmd").go
    go(dir)
end

function do_heart_beat()
    chainhelper:log(string.format("这里是&YEL&%s&NOR&的心跳。", actor_helper:get_info().name))
end

function do_deposit_qi(amount)
    assert(amount > 0, "设置的真气无效")
    nfa_helper:deposit_from(contract_base_info.caller, amount, "QI", true)
end

function do_withdraw_qi(amount)
    assert(amount > 0, "设置的真气无效")

    local nfa = nfa_helper:get_info()
    assert(nfa.qi < amount, "角色体内真气不足")

    assert(contract_base_info.caller == nfa.owner_account, "无权从角色体内提取真气")
    nfa_helper:withdraw_to(nfa.owner_account, amount, "QI", true)
end
