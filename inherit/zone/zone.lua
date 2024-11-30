-- Item = import_contract('contract.inherit.item').Item
-- Zone = Item:new()
-- Item = nil
-- 注意，可以使用如上的代码写继承类。但是如果Item不被置空，在合约被加载后遍历合约环境时，会遍历到Item表，这时会由于无限递归调用而崩溃
--  因为Item:new()会造成Item的__index键指向Item自己，从而在遍历Item表时出现无穷递归遍历
--  所以推荐如下写法：
Zone = import_contract('contract.inherit.item').Item:new()
