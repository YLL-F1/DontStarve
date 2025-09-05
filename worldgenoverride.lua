-- WeGame版本饥荒世界生成配置
-- 主世界配置

return {
    override_enabled = true,
    preset = "SURVIVAL_TOGETHER", -- 生存模式预设
    
    -- 世界大小和连接
    world_size = "default", -- default, medium, large
    branching = "default", -- default, never, least, most
    loop = "default", -- default, never, always
    
    -- 生物群落
    biomes = {
        ["moon"] = "default", -- default, never, always
        ["moon_forest"] = "default",
        ["moon_rock"] = "default",
        ["moon_fissure"] = "default",
    },
    
    -- 资源设置
    resources = {
        ["flint"] = "default", -- default, never, less, more, tons
        ["rocks"] = "default",
        ["trees"] = "default",
        ["grass"] = "default",
        ["sapling"] = "default",
        ["berrybush"] = "default",
        ["carrot"] = "default",
        ["mushroom"] = "default",
    },
    
    -- 动物设置
    animals = {
        ["rabbits"] = "default", -- default, never, less, more, tons
        ["beefalo"] = "default",
        ["pigs"] = "default",
        ["bees"] = "default",
        ["catcoons"] = "default",
        ["perd"] = "default",
        ["bunnymen"] = "default",
    },
    
    -- 怪物设置
    monsters = {
        ["spiders"] = "default", -- default, never, less, more, tons
        ["tentacles"] = "default",
        ["chess"] = "default",
        ["lureplants"] = "default",
        ["walrus"] = "default",
        ["liefs"] = "default",
        ["deciduousmonster"] = "default",
        ["krampus"] = "default",
        ["bearger"] = "default",
        ["deerclops"] = "default",
        ["goosemoose"] = "default",
        ["dragonfly"] = "default",
    },
    
    -- 季节设置
    seasons = {
        ["autumn"] = "default", -- default, short, long, verylong, none
        ["winter"] = "default",
        ["spring"] = "default",
        ["summer"] = "default",
    },
    
    -- 特殊设置
    special = {
        ["day"] = "default", -- default, longday, longdusk, longnight, noday, nodusk, nonight, onlyday, onlydusk, onlynight
        ["weather"] = "default", -- default, never, rare, often, always
        ["lightning"] = "default", -- default, never, rare, often, always
        ["frograin"] = "default", -- default, never, rare, often, always
        ["wildfires"] = "default", -- default, never, rare, often, always
        ["touchstone"] = "default", -- default, never, less, more, tons
        ["boons"] = "default", -- default, never, less, more, tons
        ["cave_entrance"] = "default", -- default, never, less, more, tons
    },
}
