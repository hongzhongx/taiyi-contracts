short = { consequence = false }
long = { consequence = false }
exits = { consequence = false }
map = { consequence = false }

function init_data()
    return {
        is_zone = true,
        unit = '处'
    }
end

function eval_short()
    return { "村口亭" }
end

function eval_long()
    return { "往南（south）是出村，往北（north)是进入村中小道，往西(west)是去往&HIC&练功房&NOR&，往东(east)是去往另一处&HIC&练功房&NOR&" }
end

function eval_exits()
    return {
        south = "牛心村",
        north = "牛心村.小道",
        west = "牛心村.练功房1",
        east = "牛心村.练功房2"
    }
end

function eval_map()
    local map = import_contract('contract.map.niuxincun')
    return { map.map_data() }
end

function on_actor_enter(actor_nfa_id)
    local actor = contract_helper:get_actor_info(actor_nfa_id)
    contract_helper:log(string.format('%s来到了村口亭', actor.name))
end
