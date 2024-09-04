struct Element: Hashable {
    
    
    
    //MARK:- Variables
    
    let symbol: String
    let isFinal: Bool
    
    private static let elements: Set = 
        [Element("💧", isFinal: false),
         Element("⛰", isFinal: false),
         Element("🔥", isFinal: false),
         Element("💨", isFinal: false),
         Element("🌊", isFinal: false),
         Element("🗻", isFinal: false),
         Element("🌫", isFinal: false),
         Element("🌧", isFinal: false),
         Element("🌬", isFinal: false),
         Element("🌋", isFinal: false),
         Element("🌱", isFinal: true),
         Element("♨️", isFinal: false),
         Element("🧂", isFinal: true),
         Element("🧱", isFinal: true),
         Element("☁️", isFinal: true),
         Element("🌌", isFinal: true),
         Element("〰️", isFinal: true),
         Element("🏝", isFinal: true),
         Element("🌪", isFinal: true)]
    
    static let elementsCount = elements.count
    
    static var userElements =
        [Element("💧", isFinal: false),
         Element("⛰", isFinal: false),
         Element("🔥", isFinal: false),
         Element("💨", isFinal: false)]
    
    
    
    //MARK:- Init
    
    init(_ symbol: String, isFinal: Bool) {
        self.symbol = symbol
        self.isFinal = isFinal
    }
    
    init?(forSymbol symbol: String) {
        guard let element = Element.elements.first(where: { $0.symbol == symbol }) else { return nil }
        self = element
    }
    
    
    
    //MARK:- Functions
    
    static func +(lhs: Element, rhs: Element) -> Element? {
        guard lhs.isFinal == false && rhs.isFinal == false else { return nil }
        var symbol: Character? = nil
        switch (lhs.symbol, rhs.symbol) {
        case ("💧", "💧"),
             ("💧", "🌊"), ("🌊", "💧"),
             ("🌊", "🌊"),
             ("🌧", "🌧"): symbol = "🌊"
        case ("💧", "⛰"), ("⛰", "💧"),
             ("💧", "🌋"), ("🌋", "💧"),
             ("⛰", "💨"), ("💨", "⛰"),
             ("💨", "🌋"), ("🌋", "💨"),
             ("🌬", "🌋"), ("🌋", "🌬"): symbol = "🗻"
        case ("💧", "🔥"), ("🔥", "💧"),
             ("💧", "♨️"), ("♨️", "💧"): symbol = "🌫"
        case ("💧", "💨"), ("💨", "💧"): symbol = "🌧"
        case ("⛰", "⛰"),
             ("⛰", "🌫"), ("🌫", "⛰"),
             ("💨", "💨"),
             ("💨", "♨️"), ("♨️", "💨"): symbol = "🌬"
        case ("⛰", "🔥"), ("🔥", "⛰"),
             ("⛰", "🌋"), ("🌋", "⛰"): symbol = "🌋"
        case ("⛰", "🌧"), ("🌧", "⛰"): symbol = "🌱"
        case ("⛰", "♨️"), ("♨️", "⛰"): symbol = "🌋"
        case ("🔥", "💨"), ("💨", "🔥"): symbol = "♨️"
        case ("🔥", "🌊"), ("🌊", "🔥"): symbol = "🧂"
        case ("🔥", "🗻"), ("🗻", "🔥"): symbol = "🧱"
        case ("💨", "🌫"), ("🌫", "💨"): symbol = "☁️"
        case ("💨", "🌬"), ("🌬", "💨"): symbol = "🌌"
        case ("🌊", "🌬"), ("🌬", "🌊"): symbol = "〰️"
        case ("🌊", "🌋"), ("🌋", "🌊"): symbol = "🏝"
        case ("🌬", "♨️"), ("♨️", "🌬"): symbol = "🌪"
        case ("🌋", "♨️"), ("♨️", "🌋"): symbol = "🌋"
        default: return nil
        }
        if let element = elements.first(where: { $0.symbol == String(symbol ?? " ") }) {
            if !userElements.contains(element) { userElements.append(element) }
            return element
        }
        return nil
    }
    
}
