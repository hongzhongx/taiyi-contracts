born_actor = { consequence = true }
place_in = { consequence = true }
take_out = { consequence = true }

-- 返回一个table
function init_data()
    return {
        name = "衍童石",
        unit = "块"
    }
end

-- 注意，这个行为的调用是从法宝的角度进来的，所以caller nfa是法宝，不是角色
-- gender; 0=random, -1=男, 1=女, -2=男生女相, 2=女生男相
-- sexuality; 0=无性取向，1=喜欢男性，2=喜欢女性，3=双性恋
function do_born_actor(actor_name, gender, sexuality, init_attrs)
    local nfa = nfa_helper:get_info()
    assert(contract_helper:is_nfa_valid(nfa.parent), "法宝未安置好")
    local parent_nfa = contract_helper:get_nfa_info(nfa.parent)
    assert(parent_nfa.data.is_zone, "法宝未安置在区域上")
    local zone = contract_helper:get_zone_info(nfa.parent)

    assert(contract_helper:is_actor_valid(actor_name), string.format('未找到名为"%s"的角色', actor_name))
    local actor = contract_helper:get_actor_info_by_name(actor_name)
    assert(actor.born == false, string.format('"%s"已经在世了', actor_name))

    assert(#init_attrs == 8, '初始属性参数的数目不匹配，必须是八个属性值')

    contract_helper:born_actor(actor_name, gender, sexuality, init_attrs, zone.name)
    -- update actor info after born
    actor = contract_helper:get_actor_info_by_name(actor_name)
    assert(actor.born == true, string.format('"%s"出生失败', actor_name))
    contract_helper:log(string.format('%d年%d月，"%s"在%s出生了', actor.born_vyears, actor.born_vmonths, actor_name, zone.name))

    -- grow as first birthday
    -- try_trigger_actor_talents(act, 0);

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
