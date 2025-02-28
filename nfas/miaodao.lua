short = { consequence = false }
long = { consequence = false }

-- 返回一个table
function init_data()
    return {        
        name = "苗刀",
        unit = "把"
    }
end

function eval_short()
    return { "苗刀" }
end

function eval_long()
  local ss = "这是一把&HIC&苗刀&NOR&，刀身有奇怪的纹路。"
  return { ss }
end

