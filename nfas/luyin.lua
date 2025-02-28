short = { consequence = false }
long = { consequence = false }
help = { consequence = false }
show_me = { consequence = false }

touch = { consequence = true }
upgrade_actor = { consequence = true }

-- 返回一个table
function init_data()
  return {        
    name = "路引",
    unit = "本",
    referee = "介绍人",
    destination = "目的地"
  }
end

function eval_help()
  local ss = [[
&WHT&『&HIY&路引可用命令&NOR&&WHT&』
    &HIG&绿色命令&NOR&为产生影响（因果）的命令，需要消耗真气并等待天道网络响应

    &WHT&help []&NOR&                    - 显示本帮助
    &WHT&show_me ["实体id"]&NOR&         - 这个，竟可以看到天道

    &HIG&touch ["来自某人"]&NOR&         - 被某人摸了一下
    &HIG&upgrade_actor ["角色名"]&NOR&   - 升级某普通人为修真者
]]
  contract_helper:narrate(ss, false)
end

function eval_short()
    return { "路引" }
end

function eval_long()
  local ss = "这是一本大梁监天司颁发的&HIC&路引&NOR&。尽管到过大梁城的都可以获得，但据说它拥有特殊的法力，不妨摸（&HIG&touch&NOR&）一下它仔细看看。"
  return { ss }
end

function do_touch(from_who)
  assert(contract_helper:is_actor_valid_by_name(from_who), string.format('未找到名为"%s"的角色', from_who))
  local actor = contract_helper:get_actor_info_by_name(from_who)
  local main_contract = contract_helper:get_nfa_info(actor.nfa_id).main_contract
  if main_contract == "contract.actor.normal" then
    do_upgrade_actor(from_who)
  else
    contract_helper:narrate(string.format('&YEL&%s&NOR&摸了摸路引，但什么也没发生', from_who), true)
  end
end

function do_upgrade_actor(actor_name)
  assert(contract_helper:is_actor_valid_by_name(actor_name), string.format('未找到名为"%s"的角色', actor_name))
  local actor = contract_helper:get_actor_info_by_name(actor_name)

  -- 角色nfa的symbol不会改变，仅仅改变nfa的主合约
  contract_helper:change_nfa_contract(actor.nfa_id, "contract.actor.cultivator")
  contract_helper:narrate(string.format('&YEL&%s&NOR&整个人发生了一些变化，体内真气似乎蠢蠢欲动', actor_name), true)
end

-- 获得指定nfa的主合约代码并打印出来
function eval_show_me(target_nfa_id)
  if contract_helper:is_nfa_valid(target_nfa_id) then
    local main_contract = contract_helper:get_nfa_info(target_nfa_id).main_contract
    contract_helper:narrate(string.format('\r\n%s', contract_helper:get_contract_source_code(main_contract)), false)
    contract_helper:narrate("&WHT&「&HIY&既见天道，为何不拜？&WHT&」&NOR&", false)
  end
end