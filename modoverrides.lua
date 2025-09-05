-- WeGame版本饥荒服务器模组配置
-- 常用模组推荐配置

return {
    -- ==================== 基础信息显示模组 ====================
    
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
    
    -- 显示时间模组
    ["workshop-378160973"] = { -- Clock
        enabled = true,
        configuration_options = {
            show_time = true,
            show_day = true,
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
    
    -- ==================== 物品和食物模组 ====================
    
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
    
    -- 显示物品信息模组
    ["workshop-378160973"] = { -- Item Info
        enabled = true,
        configuration_options = {
            show_item_info = true,
            show_recipe_info = true,
        }
    },
    
    -- ==================== 游戏体验优化模组 ====================
    
    -- 快速拾取模组
    ["workshop-378160973"] = { -- Quick Pick
        enabled = true,
        configuration_options = {
            quick_pick_range = 3,
            auto_pick = false,
        }
    },
    
    -- 自动堆叠模组
    ["workshop-378160973"] = { -- Auto Stack
        enabled = true,
        configuration_options = {
            auto_stack = true,
            stack_range = 2,
        }
    },
    
    -- 快速制作模组
    ["workshop-378160973"] = { -- Quick Craft
        enabled = true,
        configuration_options = {
            quick_craft = true,
            craft_multiple = true,
        }
    },
    
    -- 显示制作材料模组
    ["workshop-378160973"] = { -- Crafting Materials
        enabled = true,
        configuration_options = {
            show_materials = true,
            show_available = true,
        }
    },
    
    -- ==================== 地图和探索模组 ====================
    
    -- 地图标记模组
    ["workshop-378160973"] = { -- Map Markers
        enabled = true,
        configuration_options = {
            show_landmarks = true,
            show_resources = true,
            show_dangers = true,
        }
    },
    
    -- 显示生物信息模组
    ["workshop-378160973"] = { -- Creature Info
        enabled = true,
        configuration_options = {
            show_health = true,
            show_aggro = true,
            show_drops = true,
        }
    },
    
    -- ==================== 服务器管理模组 ====================
    
    -- 服务器信息模组
    ["workshop-378160973"] = { -- Server Info
        enabled = true,
        configuration_options = {
            show_server_info = true,
            show_player_count = true,
            show_server_time = true,
        }
    },
    
    -- 玩家列表模组
    ["workshop-378160973"] = { -- Player List
        enabled = true,
        configuration_options = {
            show_players = true,
            show_ping = true,
            show_playtime = true,
        }
    },
    
    -- ==================== 实用工具模组 ====================
    
    -- 显示距离模组
    ["workshop-378160973"] = { -- Distance
        enabled = true,
        configuration_options = {
            show_distance = true,
            show_range = true,
        }
    },
    
    -- 显示耐久度模组
    ["workshop-378160973"] = { -- Durability
        enabled = true,
        configuration_options = {
            show_durability = true,
            show_repair_info = true,
        }
    },
    
    -- 显示天气模组
    ["workshop-378160973"] = { -- Weather
        enabled = true,
        configuration_options = {
            show_weather = true,
            show_forecast = true,
        }
    },
    
    -- ==================== 装备和背包模组 ====================
    
    -- 五格装备栏模组
    ["workshop-378160973"] = { -- Extra Equip Slots
        enabled = true,
        configuration_options = {
            extra_slots = 2,  -- 额外装备栏数量
            show_slots = true,  -- 显示装备栏
            auto_equip = false,  -- 自动装备
        }
    },
    
    -- 扩展背包模组
    ["workshop-378160973"] = { -- Backpack Plus
        enabled = true,
        configuration_options = {
            backpack_size = 20,  -- 背包大小
            show_items = true,  -- 显示物品
            auto_sort = true,  -- 自动整理
        }
    },
    
    -- 装备耐久度显示模组
    ["workshop-378160973"] = { -- Equipment Durability
        enabled = true,
        configuration_options = {
            show_durability = true,  -- 显示耐久度
            show_repair_cost = true,  -- 显示修复成本
            warn_low_durability = true,  -- 低耐久度警告
        }
    },
    
    -- ==================== 可选模组 ====================
    
    -- 显示伤害数字模组
    ["workshop-378160973"] = { -- Damage Numbers
        enabled = false,
        configuration_options = {
            show_damage = true,
            show_healing = true,
        }
    },
    
    -- 显示经验值模组
    ["workshop-378160973"] = { -- Experience
        enabled = false,
        configuration_options = {
            show_exp = true,
            show_level = true,
        }
    },
    
    -- 显示饥饿值模组
    ["workshop-378160973"] = { -- Hunger
        enabled = false,
        configuration_options = {
            show_hunger_rate = true,
            show_food_effects = true,
        }
    },
}
