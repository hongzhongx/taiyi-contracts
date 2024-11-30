-- Object = import_contract('contract.inherit.object').Object
-- Item = Object:new()
-- Object = nil
-- 注意，可以使用如上的代码写继承类。但是如果Object不被置空，在合约被加载后遍历合约环境时，会遍历到Object表，这时会由于无限递归调用而崩溃
--  因为Object:new()会造成Object的__index键指向Object自己，从而在遍历Object表时出现无穷递归遍历
--  所以推荐如下写法：
Item = import_contract('contract.inherit.object').Object:new()

function Item:short()
    local me = self.me
    if me.nfa_id == nil then
        return "未知事物"
    end

    local result = contract_helper:eval_nfa_action(me.nfa_id, "short", {})
    if #result == 1 then
        return result[1]
    end

    if me.name ~= nil then
        return me.name
    end

    local nfa = contract_helper:get_nfa_info(me.nfa_id)
    if nfa.data.name ~= nil then
        return nfa.data.name
    end

    return "未知事物"
end

function Item:long()
    local me = self.me
    if me.nfa_id == nil then
        return "未知事物"
    end

    local result = contract_helper:eval_nfa_action(me.nfa_id, "long", {})
    if #result == 1 then
        return result[1]
    end

    if me.description ~= nil then
        return me.description
    end

    local nfa = contract_helper:get_nfa_info(me.nfa_id)
    if nfa.data.description ~= nil then
        return nfa.data.description
    end

    return self:short()
end

function Item:data()
    local me = self.me
    if me.nfa_id == nil then
        return {}
    end

    local nfa = contract_helper:get_nfa_info(me.nfa_id)
    return nfa.data
end

function Item:unit()
    local data = self:data()
    if data.unit ~= nil then
        return data.unit
    end

    return '个'
end