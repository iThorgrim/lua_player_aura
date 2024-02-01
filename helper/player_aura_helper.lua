return {
    DATABASE = {
        NAME = "335_dev_eluna",
        CONDITIONS = "player_aura_conditions",
        RELATIONS = "player_aura_relations",

        AURAS = {
            CREATE = [[
                CREATE TABLE IF NOT EXISTS %s.`player_aura_index` ( `id` int(10) NOT NULL,
                    `spell_id` int(10) NOT NULL,
                    `stack` int(10) NOT NULL DEFAULT 1,
                    PRIMARY KEY (`id`,`spell_id`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;]],
            READ   = "SELECT * FROM %s.player_aura_index;"
        },
    },

    ENUM = {
        METHOD = { }
    },
}
