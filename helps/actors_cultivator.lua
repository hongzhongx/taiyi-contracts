local ss = [[
&WHT&『&HIY&修真者可用命令&NOR&&WHT&』
    &HIG&绿色命令&NOR&为产生影响（因果）的命令，需要消耗真气并等待天道网络响应

    &WHT&help []&NOR&                   - 显示本帮助
    &WHT&look ["目标"]&NOR&             - 查看目标，目标为空表示查看四周
    &WHT&inventory ["目标", "选项"]&NOR&- 查看目标的物品清单，目标为空表示查看自己。选项为"-l"时展开列表
    &WHT&hp ["目标","选项"]&NOR&        - 查看目标的状态或者基础属性，目标为空表示查看自己；选项为""表示查状态，"-c"表示查看属性
    &WHT&resource ["目标","选项"]&NOR&  - 查看目标拥有的资源或者材质，目标为空表示查看自己；选项为""表示查资源，"-m"表示查看材质
    &WHT&map ["目标"]&NOR&              - 查看地图，目标为空表示查看当前区域地图

    &HIG&go ["方向"]&NOR&               - 移动到指定方向
    &HIG&eat ["物品"]&NOR&              - 吃东西，可以补充真气体力
    &HIG&exploit ["目标"]&NOR&          - 开采和探索，可以获得资源或者物品，目标为空表示探索当前区域，目标为"zone"表示开辟周围的新区域
    &HIG&start_cultivation []&NOR&      - 开始炼气，以自身一半的真气开启一次简单的养生活动
    &HIG&stop_cultivation []&NOR&       - 停止炼气，结束本次养生修真，可以获得少量真气
    &HIG&deposit_qi [数量]&NOR&         - 直接从神魂注入先天真气到角色体内（补气）
    &HIG&withdraw_qi [数量]&NOR&        - 直接从角色体内提取先天真气到神魂
    &HIG&active []&NOR&                 - 激活内息运转，开启自动炼气
    &HIG&touch ["物品"]&NOR&            - 触摸一下指定物品
    &HIG&talk ["对象","内容"]&NOR&       - 和指定对象谈话，内容不能为空
]]

function help()
	contract_helper:narrate(ss, false)
end
