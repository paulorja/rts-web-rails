BLACKSMITH = {
    pick: {
        title: 'Picareta',
        up_column: 'blacksmith_pick',
        levels: [
            { production: 50,  time: 0,      gold: 0 },
            { production: 55,  time: 500,    gold: 500 },
            { production: 60,  time: 1000,   gold: 1000 },
            { production: 65,  time: 2000,   gold: 2000 },
            { production: 70,  time: 4000,   gold: 4000 },
            { production: 75,  time: 8000,   gold: 8000 },
            { production: 80,  time: 16000,  gold: 16000 },
            { production: 85,  time: 32000,  gold: 32000 },
            { production: 90,  time: 64000,  gold: 64000 },
            { production: 95,  time: 128000, gold: 128000 },
            { production: 100, time: 256000, gold: 256000 },
        ]
    },
    hoe: {
        title: 'Enxada',
        up_column: 'blacksmith_hoe',
        levels: [
            { production: 50,  time: 0,      gold: 0 },
            { production: 55,  time: 500,    gold: 500 },
            { production: 60,  time: 1000,   gold: 1000 },
            { production: 65,  time: 2000,   gold: 2000 },
            { production: 70,  time: 4000,   gold: 4000 },
            { production: 75,  time: 8000,   gold: 8000 },
            { production: 80,  time: 16000,  gold: 16000 },
            { production: 85,  time: 32000,  gold: 32000 },
            { production: 90,  time: 64000,  gold: 64000 },
            { production: 95,  time: 128000, gold: 128000 },
            { production: 100, time: 256000, gold: 256000 },
        ]
    },
    axe: {
        title: 'Machado',
        up_column: 'blacksmith_axe',
        levels: [
            { production: 50,  time: 0,      gold: 0 },
            { production: 55,  time: 500,    gold: 500 },
            { production: 60,  time: 1000,   gold: 1000 },
            { production: 65,  time: 2000,   gold: 2000 },
            { production: 70,  time: 4000,   gold: 4000 },
            { production: 75,  time: 8000,   gold: 8000 },
            { production: 80,  time: 16000,  gold: 16000 },
            { production: 85,  time: 32000,  gold: 32000 },
            { production: 90,  time: 64000,  gold: 64000 },
            { production: 95,  time: 128000, gold: 128000 },
            { production: 100, time: 256000, gold: 256000 },
        ]
    }
}

class Blacksmith
    def self.get_item(up_column)
        BLACKSMITH.each do |b|
            if b[1][:up_column] == up_column
                return b[1]
            end
        end
        nil
    end
end
