@building_data = {
    name: 'Mina de Ouro',
    code: 7,
    css_class: 'sprite-gold-mine',
    terrain: :gold,
    action: 'mine',
    levels: [
        {
        },
        {
            stone: 125,
            wood: 125,
            time: 25,
            score: 1
        },
        {
            wood: 850,
            stone: 850,
            time: 480,
            score: 1,
            castle_level: 3
        },
        {
            wood: 3850,
            stone: 3850,
            time: 2250,
            score: 2,
            castle_level: 4
        }
    ]
}