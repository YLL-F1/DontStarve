-- WeGame版本饥荒服务器模组配置
-- 常用模组推荐配置

return {
    -- 服务器信息模组
    ["workshop-378160973"] = { -- Server Info
        enabled = true,
        configuration_options = {
            show_server_info = true,
            show_player_count = true,
            show_server_time = true,
        }
    },
    
    -- 全球定位模组
    ["workshop-378160973"] = { -- Global Positions
        enabled = true,
        configuration_options = {
            share_minimap = true,
            share_map = true,
        }
    },
    
    -- 显示血量模组
    ["workshop-378160973"] = { -- Health Info
        enabled = true,
        configuration_options = {
            show_health = true,
            show_hunger = true,
            show_sanity = true,
        }
    },
    
    -- 快速拾取模组
    ["workshop-378160973"] = { -- Quick Pick
        enabled = true,
        configuration_options = {
            quick_pick_range = 3,
            auto_pick = false,
        }
    },
    
    -- 显示食物属性模组
    ["workshop-378160973"] = { -- Food Values
        enabled = true,
        configuration_options = {
            show_food_values = true,
            show_cooking_time = true,
        }
    },
    
    -- 显示物品堆叠模组
    ["workshop-378160973"] = { -- Item Stack
        enabled = true,
        configuration_options = {
            show_stack_size = true,
            show_durability = true,
        }
    },
    
    -- 显示季节模组
    ["workshop-378160973"] = { -- Season Clock
        enabled = true,
        configuration_options = {
            show_season = true,
            show_days = true,
            show_temperature = true,
        }
    },
    
    -- 显示坐标模组
    ["workshop-378160973"] = { -- Coordinates
        enabled = true,
        configuration_options = {
            show_coordinates = true,
            show_biome = true,
        }
    },
    
    -- 显示温度模组
    ["workshop-378160973"] = { -- Temperature
        enabled = true,
        configuration_options = {
            show_temperature = true,
            show_weather = true,
        }
    },
    
    -- 显示时间模组
    ["workshop-378160973"] = { -- Clock
        enabled = true,
        configuration_options = {
            show_time = true,
            show_day = true,
        }
    },
}
