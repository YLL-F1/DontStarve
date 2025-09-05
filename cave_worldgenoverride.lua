-- WeGame版本饥荒洞穴世界生成配置

return {
    override_enabled = true,
    preset = "DST_CAVE", -- 洞穴预设
    
    -- 洞穴大小
    world_size = "default", -- default, medium, large
    
    -- 生物群落
    biomes = {
        ["cave"] = "default", -- default, never, always
        ["mud"] = "default",
        ["sinkhole"] = "default",
        ["rocky"] = "default",
        ["batcave"] = "default",
        ["rabbitcity"] = "default",
        ["ruins"] = "default",
    },
    
    -- 资源设置
    resources = {
        ["rocks"] = "default", -- default, never, less, more, tons
        ["flint"] = "default",
        ["gold"] = "default",
        ["marble"] = "default",
        ["thulecite"] = "default",
        ["moon_rock"] = "default",
    },
    
    -- 动物设置
    animals = {
        ["rabbits"] = "default", -- default, never, less, more, tons
        ["bunnymen"] = "default",
        ["slurper"] = "default",
        ["bats"] = "default",
        ["spiders"] = "default",
    },
    
    -- 怪物设置
    monsters = {
        ["spiders"] = "default", -- default, never, less, more, tons
        ["tentacles"] = "default",
        ["chess"] = "default",
        ["lureplants"] = "default",
        ["worm"] = "default",
        ["slurper"] = "default",
        ["bats"] = "default",
        ["fissure"] = "default",
        ["nightmare"] = "default",
        ["crawlingnightmare"] = "default",
        ["terrorbeak"] = "default",
    },
    
    -- 特殊设置
    special = {
        ["day"] = "default", -- default, longday, longdusk, longnight, noday, nodusk, nonight, onlyday, onlydusk, onlynight
        ["weather"] = "default", -- default, never, rare, often, always
        ["earthquakes"] = "default", -- default, never, rare, often, always
        ["boons"] = "default", -- default, never, less, more, tons
        ["touchstone"] = "default", -- default, never, less, more, tons
        ["ruins"] = "default", -- default, never, less, more, tons
        ["nightmare"] = "default", -- default, never, less, more, tons
    },
}
