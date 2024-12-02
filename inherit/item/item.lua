-- Object = import_contract('contract.inherit.object').Object
-- Item = Object:new()
-- Object = nil
-- 注意，可以使用如上的代码写继承类。但是如果Object不被置空，在合约被加载后遍历合约环境时，会遍历到Object表，这时会由于无限递归调用而崩溃
--  因为Object:new()会造成Object的__index键指向Object自己，从而在遍历Object表时出现无穷递归遍历
--  所以推荐如下写法：
Item = import_contract('contract.inherit.object').Object:new()

-- 重载new，识别nfa
function Item:new (o)
    o = {me = o or {}}
    o.nfa_info = {}
    if o.me.id ~= nil then
        if contract_helper:is_nfa_valid(o.me.id) then
            o.nfa_info = contract_helper:get_nfa_info(o.me.id)
        end
    elseif o.me.nfa_id ~= nil then
        if contract_helper:is_nfa_valid(o.me.nfa_id) then
            o.nfa_info = contract_helper:get_nfa_info(o.me.nfa_id)
        end
    end
    o.__super = self
    self.__index = self
    setmetatable(o, self)
    return o
end

function Item:short()
    if self.nfa_info.id == nil then
        return "未知事物"
    end

    local result = contract_helper:eval_nfa_action(self.nfa_info.id, "short", {})
    if #result == 1 then
        return result[1]
    end

    if self.me.name ~= nil then
        return self.me.name
    end

    if self.nfa_info.data.name ~= nil then
        return self.nfa_info.data.name
    end

    return "未知事物"
end

function Item:long()
    if self.nfa_info.id == nil then
        return "未知事物"
    end

    local result = contract_helper:eval_nfa_action(self.nfa_info.id, "long", {})
    if #result == 1 then
        return result[1]
    end

    if self.me.description ~= nil then
        return self.me.description
    end

    if self.nfa_info.data.description ~= nil then
        return self.nfa_info.data.description
    end

    return self:short()
end

function Item:data()
    if self.nfa_info.data == nil then
        return {}
    else
        return self.nfa_info.data
    end
end

function Item:unit()
    local data = self:data()
    if data.unit ~= nil then
        return data.unit
    end

    return '个'
end