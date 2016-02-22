//
//  KeyboardKey.swift
//  October
//
//  Created by Luc Succes on 7/14/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import Foundation

enum Letter: Character {
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case H = "H"
    case I = "I"
    case J = "J"
    case K = "K"
    case L = "L"
    case M = "M"
    case N = "N"
    case O = "O"
    case P = "P"
    case Q = "Q"
    case R = "R"
    case S = "S"
    case T = "T"
    case U = "U"
    case V = "V"
    case W = "W"
    case X = "X"
    case Y = "Y"
    case Z = "Z"
}

enum Digit: Character {
    case Zero = "0"
    case One = "1"
    case Two = "2"
    case Three = "3"
    case Four = "4"
    case Five = "5"
    case Six = "6"
    case Seven = "7"
    case Eight = "8"
    case Nine = "9"
}

enum SpecialCharacter: Character {
    case Hyphen = "-"
    case Slash = "/"
    case Colon = ":"
    case Semicolon = ";"
    case OpenParenthesis = "("
    case CloseParenthesis = ")"
    case DollarSign = "$"
    case Ampersand = "&"
    case At = "@"
    case Quote = "\""
    case Period = "."
    case Comma = ","
    case QuestionMark = "?"
    case ExclamationMark = "!"
    case SingleQuote = "'"
    case OpenBracket = "["
    case CloseBracket = "]"
    case OpenBrace = "{"
    case CloseBrace = "}"
    case Hashtag = "#"
    case Percent = "%"
    case Caret = "^"
    case Asterisk = "*"
    case Plus = "+"
    case Equal = "="
    case Underscore = "_"
    case Backslash = "\\"
    case Line = "|"
    case Tilda = "~"
    case LessThan = "<"
    case GreaterThan = ">"
    case Euro = "€"
    case PoundSterling = "£"
    case Dot = "·"
}

enum Modifier: String {
    case Space = "Space"
    case CapsLock = "CapsLock"
    case Backspace = "Backspace"
    case Enter = "Enter"
    case SwitchKeyboard = "SwitchKeyboard"
    case SearchMode = "SearchMode"
    case Share = "Share"
    case CallService = "CallService"
}

/**
 case ⭐ = "⭐"
 case ☀️ = "☀️"
 case ⛅ = "⛅"
 case ☁️ = "☁️"
 case ⚡️ = "⚡️"
 case ☔️ = "☔️"
 case ❄️ = "❄️"
 case ⛄️ = "⛄️"
 */

enum NatureEmoji: Character {
    case 🐶 = "🐶"
    case 🐺 = "🐺"
    case 🐱 = "🐱"
    case 🐭 = "🐭"
    case 🐹 = "🐹"
    case 🐰 = "🐰"
    case 🐸 = "🐸"
    case 🐯 = "🐯"
    case 🐨 = "🐨"
    case 🐻 = "🐻"
    case 🐷 = "🐷"
    case 🐽 = "🐽"
    case 🐮 = "🐮"
    case 🐗 = "🐗"
    case 🐵 = "🐵"
    case 🐒 = "🐒"
    case 🐴 = "🐴"
    case 🐑 = "🐑"
    case 🐘 = "🐘"
    case 🐼 = "🐼"
    case 🐧 = "🐧"
    case 🐦 = "🐦"
    case 🐤 = "🐤"
    case 🐥 = "🐥"
    case 🐣 = "🐣"
    case 🐔 = "🐔"
    case 🐍 = "🐍"
    case 🐢 = "🐢"
    case 🐛 = "🐛"
    case 🐝 = "🐝"
    case 🐜 = "🐜"
    case 🐞 = "🐞"
    case 🐌 = "🐌"
    case 🐙 = "🐙"
    case 🐚 = "🐚"
    case 🐠 = "🐠"
    case 🐟 = "🐟"
    case 🐬 = "🐬"
    case 🐳 = "🐳"
    case 🐋 = "🐋"
    case 🐄 = "🐄"
    case 🐏 = "🐏"
    case 🐀 = "🐀"
    case 🐃 = "🐃"
    case 🐅 = "🐅"
    case 🐇 = "🐇"
    case 🐉 = "🐉"
    case 🐎 = "🐎"
    case 🐐 = "🐐"
    case 🐓 = "🐓"
    case 🐕 = "🐕"
    case 🐖 = "🐖"
    case 🐁 = "🐁"
    case 🐂 = "🐂"
    case 🐲 = "🐲"
    case 🐡 = "🐡"
    case 🐊 = "🐊"
    case 🐫 = "🐫"
    case 🐪 = "🐪"
    case 🐆 = "🐆"
    case 🐈 = "🐈"
    case 🐩 = "🐩"
    case 🐾 = "🐾"
    case 💐 = "💐"
    case 🌸 = "🌸"
    case 🌷 = "🌷"
    case 🍀 = "🍀"
    case 🌹 = "🌹"
    case 🌻 = "🌻"
    case 🌺 = "🌺"
    case 🍁 = "🍁"
    case 🍃 = "🍃"
    case 🍂 = "🍂"
    case 🌿 = "🌿"
    case 🌾 = "🌾"
    case 🍄 = "🍄"
    case 🌵 = "🌵"
    case 🌴 = "🌴"
    case 🌲 = "🌲"
    case 🌳 = "🌳"
    case 🌰 = "🌰"
    case 🌱 = "🌱"
    case 🌼 = "🌼"
    case 🌐 = "🌐"
    case 🌞 = "🌞"
    case 🌝 = "🌝"
    case 🌚 = "🌚"
    case 🌑 = "🌑"
    case 🌒 = "🌒"
    case 🌓 = "🌓"
    case 🌔 = "🌔"
    case 🌕 = "🌕"
    case 🌖 = "🌖"
    case 🌗 = "🌗"
    case 🌘 = "🌘"
    case 🌜 = "🌜"
    case 🌛 = "🌛"
    case 🌙 = "🌙"
    case 🌍 = "🌍"
    case 🌎 = "🌎"
    case 🌏 = "🌏"
    case 🌋 = "🌋"
    case 🌌 = "🌌"
    case 🌠 = "🌠"
    
    case 🌀 = "🌀"
    case 🌁 = "🌁"
    case 🌈 = "🌈"
    case 🌊 = "🌊"
}

/**
 case ☎ = "☎"
 
 case ⏳ = "⏳"
 case ⌛ = "⌛"
 case ⏰ = "⏰"
 case ⌚ = "⌚"
 
 case ✉ = "✉"
 
 case ✂ = "✂"
 
 case ✒ = "✒"
 case ✏ = "✏"
 
 case ⚽ = "⚽"
 case ⚾ = "⚾"
 
 case ⛳ = "⛳"
 
 case ☕ = "☕"
 
 */
enum ObjectEmoji: Character {
    case 🎍 = "🎍"
    case 💝 = "💝"
    case 🎎 = "🎎"
    case 🎒 = "🎒"
    case 🎓 = "🎓"
    case 🎏 = "🎏"
    case 🎆 = "🎆"
    case 🎇 = "🎇"
    case 🎐 = "🎐"
    case 🎑 = "🎑"
    case 🎃 = "🎃"
    case 👻 = "👻"
    case 🎅 = "🎅"
    case 🎄 = "🎄"
    case 🎁 = "🎁"
    case 🎋 = "🎋"
    case 🎉 = "🎉"
    case 🎊 = "🎊"
    case 🎈 = "🎈"
    case 🎌 = "🎌"
    case 🔮 = "🔮"
    case 🎥 = "🎥"
    case 📷 = "📷"
    case 📹 = "📹"
    case 📼 = "📼"
    case 💿 = "💿"
    case 📀 = "📀"
    case 💽 = "💽"
    case 💾 = "💾"
    case 💻 = "💻"
    case 📱 = "📱"
    
    case 📞 = "📞"
    case 📟 = "📟"
    case 📠 = "📠"
    case 📡 = "📡"
    case 📺 = "📺"
    case 📻 = "📻"
    case 🔊 = "🔊"
    case 🔉 = "🔉"
    case 🔈 = "🔈"
    case 🔇 = "🔇"
    case 🔔 = "🔔"
    case 🔕 = "🔕"
    case 📢 = "📢"
    case 📣 = "📣"
    
    case 🔓 = "🔓"
    case 🔒 = "🔒"
    case 🔏 = "🔏"
    case 🔐 = "🔐"
    case 🔑 = "🔑"
    case 🔎 = "🔎"
    case 💡 = "💡"
    case 🔦 = "🔦"
    case 🔆 = "🔆"
    case 🔅 = "🔅"
    case 🔌 = "🔌"
    case 🔋 = "🔋"
    case 🔍 = "🔍"
    case 🛁 = "🛁"
    case 🛀 = "🛀"
    case 🚿 = "🚿"
    case 🚽 = "🚽"
    case 🔧 = "🔧"
    case 🔩 = "🔩"
    case 🔨 = "🔨"
    case 🚪 = "🚪"
    case 🚬 = "🚬"
    case 💣 = "💣"
    case 🔫 = "🔫"
    case 🔪 = "🔪"
    case 💊 = "💊"
    case 💉 = "💉"
    case 💰 = "💰"
    case 💴 = "💴"
    case 💵 = "💵"
    case 💷 = "💷"
    case 💶 = "💶"
    case 💳 = "💳"
    case 💸 = "💸"
    case 📲 = "📲"
    case 📧 = "📧"
    case 📥 = "📥"
    case 📤 = "📤"
    
    case 📩 = "📩"
    case 📨 = "📨"
    case 📯 = "📯"
    case 📫 = "📫"
    case 📪 = "📪"
    case 📬 = "📬"
    case 📭 = "📭"
    case 📮 = "📮"
    case 📦 = "📦"
    case 📝 = "📝"
    case 📄 = "📄"
    case 📃 = "📃"
    case 📑 = "📑"
    case 📊 = "📊"
    case 📈 = "📈"
    case 📉 = "📉"
    case 📜 = "📜"
    case 📋 = "📋"
    case 📅 = "📅"
    case 📆 = "📆"
    case 📇 = "📇"
    case 📁 = "📁"
    case 📂 = "📂"
    
    case 📌 = "📌"
    case 📎 = "📎"
    
    case 📏 = "📏"
    case 📐 = "📐"
    case 📕 = "📕"
    case 📗 = "📗"
    case 📘 = "📘"
    case 📙 = "📙"
    case 📓 = "📓"
    case 📔 = "📔"
    case 📒 = "📒"
    case 📚 = "📚"
    case 📖 = "📖"
    case 🔖 = "🔖"
    case 📛 = "📛"
    case 🔬 = "🔬"
    case 🔭 = "🔭"
    case 📰 = "📰"
    case 🎨 = "🎨"
    case 🎬 = "🎬"
    case 🎤 = "🎤"
    case 🎧 = "🎧"
    case 🎼 = "🎼"
    case 🎵 = "🎵"
    case 🎶 = "🎶"
    case 🎹 = "🎹"
    case 🎻 = "🎻"
    case 🎺 = "🎺"
    case 🎷 = "🎷"
    case 🎸 = "🎸"
    case 👾 = "👾"
    case 🎮 = "🎮"
    case 🃏 = "🃏"
    case 🎴 = "🎴"
    case 🀄 = "🀄"
    case 🎲 = "🎲"
    case 🎯 = "🎯"
    case 🏈 = "🏈"
    case 🏀 = "🏀"
    
    case 🎾 = "🎾"
    case 🎱 = "🎱"
    case 🏉 = "🏉"
    case 🎳 = "🎳"
    
    case 🚵 = "🚵"
    case 🚴 = "🚴"
    case 🏁 = "🏁"
    case 🏇 = "🏇"
    case 🏆 = "🏆"
    case 🎿 = "🎿"
    case 🏂 = "🏂"
    case 🏊 = "🏊"
    case 🏄 = "🏄"
    case 🎣 = "🎣"
    
    case 🍵 = "🍵"
    case 🍶 = "🍶"
    case 🍼 = "🍼"
    case 🍺 = "🍺"
    case 🍻 = "🍻"
    case 🍸 = "🍸"
    case 🍹 = "🍹"
    case 🍷 = "🍷"
    case 🍴 = "🍴"
    case 🍕 = "🍕"
    case 🍔 = "🍔"
    case 🍟 = "🍟"
    case 🍗 = "🍗"
    case 🍖 = "🍖"
    case 🍝 = "🍝"
    case 🍛 = "🍛"
    case 🍤 = "🍤"
    case 🍱 = "🍱"
    case 🍣 = "🍣"
    case 🍥 = "🍥"
    case 🍙 = "🍙"
    case 🍘 = "🍘"
    case 🍚 = "🍚"
    case 🍜 = "🍜"
    case 🍲 = "🍲"
    case 🍢 = "🍢"
    case 🍡 = "🍡"
    case 🍳 = "🍳"
    case 🍞 = "🍞"
    case 🍩 = "🍩"
    case 🍮 = "🍮"
    case 🍦 = "🍦"
    case 🍨 = "🍨"
    case 🍧 = "🍧"
    case 🎂 = "🎂"
    case 🍰 = "🍰"
    case 🍪 = "🍪"
    case 🍫 = "🍫"
    case 🍬 = "🍬"
    case 🍭 = "🍭"
    case 🍯 = "🍯"
    case 🍎 = "🍎"
    case 🍏 = "🍏"
    case 🍊 = "🍊"
    case 🍋 = "🍋"
    case 🍒 = "🍒"
    case 🍇 = "🍇"
    case 🍉 = "🍉"
    case 🍓 = "🍓"
    case 🍑 = "🍑"
    case 🍈 = "🍈"
    case 🍌 = "🍌"
    case 🍐 = "🍐"
    case 🍍 = "🍍"
    case 🍠 = "🍠"
    case 🍆 = "🍆"
    case 🍅 = "🍅"
    case 🌽 = "🌽"
}

/**
 case ☺ = "☺"
 
 case ✨ = "✨"
 
 case ✊ = "✊"
 case ✌ = "✌"
 
 case ✋ = "✋"
 
 case ☝ = "☝"
 
 case ❤ = "❤"
 
 */
enum PeopleEmoji: Character {
    case 😄 = "😄"
    case 😃 = "😃"
    case 😀 = "😀"
    case 😊 = "😊"
    
    case 😉 = "😉"
    case 😍 = "😍"
    case 😘 = "😘"
    case 😚 = "😚"
    case 😗 = "😗"
    case 😙 = "😙"
    case 😜 = "😜"
    case 😝 = "😝"
    case 😛 = "😛"
    case 😳 = "😳"
    case 😁 = "😁"
    case 😔 = "😔"
    case 😌 = "😌"
    case 😒 = "😒"
    case 😞 = "😞"
    case 😣 = "😣"
    case 😢 = "😢"
    case 😂 = "😂"
    case 😭 = "😭"
    case 😪 = "😪"
    case 😥 = "😥"
    case 😰 = "😰"
    case 😅 = "😅"
    case 😓 = "😓"
    case 😩 = "😩"
    case 😫 = "😫"
    case 😨 = "😨"
    case 😱 = "😱"
    case 😠 = "😠"
    case 😡 = "😡"
    case 😤 = "😤"
    case 😖 = "😖"
    case 😆 = "😆"
    case 😋 = "😋"
    case 😷 = "😷"
    case 😎 = "😎"
    case 😴 = "😴"
    case 😵 = "😵"
    case 😲 = "😲"
    case 😟 = "😟"
    case 😦 = "😦"
    case 😧 = "😧"
    case 😈 = "😈"
    case 👿 = "👿"
    case 😮 = "😮"
    case 😬 = "😬"
    case 😐 = "😐"
    case 😕 = "😕"
    case 😯 = "😯"
    case 😶 = "😶"
    case 😇 = "😇"
    case 😏 = "😏"
    case 😑 = "😑"
    case 👲 = "👲"
    case 👳 = "👳"
    case 👮 = "👮"
    case 👷 = "👷"
    case 💂 = "💂"
    case 👶 = "👶"
    case 👦 = "👦"
    case 👧 = "👧"
    case 👨 = "👨"
    case 👩 = "👩"
    case 👴 = "👴"
    case 👵 = "👵"
    case 👱 = "👱"
    case 👼 = "👼"
    case 👸 = "👸"
    case 😺 = "😺"
    case 😸 = "😸"
    case 😻 = "😻"
    case 😽 = "😽"
    case 😼 = "😼"
    case 🙀 = "🙀"
    case 😿 = "😿"
    case 😹 = "😹"
    case 😾 = "😾"
    case 👹 = "👹"
    case 👺 = "👺"
    case 🙈 = "🙈"
    case 🙉 = "🙉"
    case 🙊 = "🙊"
    case 💀 = "💀"
    case 👽 = "👽"
    case 💩 = "💩"
    case 🔥 = "🔥"
    
    case 🌟 = "🌟"
    case 💫 = "💫"
    case 💥 = "💥"
    case 💢 = "💢"
    case 💦 = "💦"
    case 💧 = "💧"
    case 💤 = "💤"
    case 💨 = "💨"
    case 👂 = "👂"
    case 👀 = "👀"
    case 👃 = "👃"
    case 👅 = "👅"
    case 👄 = "👄"
    case 👍 = "👍"
    case 👎 = "👎"
    case 👌 = "👌"
    case 👊 = "👊"
    
    case 👋 = "👋"
    
    case 👐 = "👐"
    case 👆 = "👆"
    case 👇 = "👇"
    case 👉 = "👉"
    case 👈 = "👈"
    case 🙌 = "🙌"
    case 🙏 = "🙏"
    
    case 👏 = "👏"
    case 💪 = "💪"
    case 🚶 = "🚶"
    case 🏃 = "🏃"
    case 💃 = "💃"
    case 👫 = "👫"
    case 👪 = "👪"
    case 👬 = "👬"
    case 👭 = "👭"
    case 💏 = "💏"
    case 💑 = "💑"
    case 👯 = "👯"
    case 🙆 = "🙆"
    case 🙅 = "🙅"
    case 💁 = "💁"
    case 🙋 = "🙋"
    case 💆 = "💆"
    case 💇 = "💇"
    case 💅 = "💅"
    case 👰 = "👰"
    case 🙎 = "🙎"
    case 🙍 = "🙍"
    case 🙇 = "🙇"
    case 🎩 = "🎩"
    case 👑 = "👑"
    case 👒 = "👒"
    case 👟 = "👟"
    case 👞 = "👞"
    case 👡 = "👡"
    case 👠 = "👠"
    case 👢 = "👢"
    case 👕 = "👕"
    case 👔 = "👔"
    case 👚 = "👚"
    case 👗 = "👗"
    case 🎽 = "🎽"
    case 👖 = "👖"
    case 👘 = "👘"
    case 👙 = "👙"
    case 💼 = "💼"
    case 👜 = "👜"
    case 👝 = "👝"
    case 👛 = "👛"
    case 👓 = "👓"
    case 🎀 = "🎀"
    case 🌂 = "🌂"
    case 💄 = "💄"
    case 💛 = "💛"
    case 💙 = "💙"
    case 💜 = "💜"
    case 💚 = "💚"
    
    case 💔 = "💔"
    case 💗 = "💗"
    case 💓 = "💓"
    case 💕 = "💕"
    case 💖 = "💖"
    case 💞 = "💞"
    case 💘 = "💘"
    case 💌 = "💌"
    case 💋 = "💋"
    case 💍 = "💍"
    case 💎 = "💎"
    case 👤 = "👤"
    case 👥 = "👥"
    case 💬 = "💬"
    case 👣 = "👣"
    case 💭 = "💭"
}

/**
 case ⛪ = "⛪"
 
 case ⛺ = "⛺"
 
 case ⛲ = "⛲"
 
 case ⛵ = "⛵"
 
 case ⚓ = "⚓"
 
 case ✈ = "✈"
 
 case ⚠ = "⚠"
 
 case ⛽ = "⛽"
 
 case ♨ = "♨"
 */
enum PlaceEmoji: Character {
    case 🏠 = "🏠"
    case 🏡 = "🏡"
    case 🏫 = "🏫"
    case 🏢 = "🏢"
    case 🏣 = "🏣"
    case 🏥 = "🏥"
    case 🏦 = "🏦"
    case 🏪 = "🏪"
    case 🏩 = "🏩"
    case 🏨 = "🏨"
    case 💒 = "💒"
    
    case 🏬 = "🏬"
    case 🏤 = "🏤"
    case 🌇 = "🌇"
    case 🌆 = "🌆"
    case 🏯 = "🏯"
    case 🏰 = "🏰"
    
    case 🏭 = "🏭"
    case 🗼 = "🗼"
    case 🗾 = "🗾"
    case 🗻 = "🗻"
    case 🌄 = "🌄"
    case 🌅 = "🌅"
    case 🌃 = "🌃"
    case 🗽 = "🗽"
    case 🌉 = "🌉"
    case 🎠 = "🎠"
    case 🎡 = "🎡"
    
    case 🎢 = "🎢"
    case 🚢 = "🚢"
    
    case 🚤 = "🚤"
    case 🚣 = "🚣"
    
    case 🚀 = "🚀"
    
    case 💺 = "💺"
    case 🚁 = "🚁"
    case 🚂 = "🚂"
    case 🚊 = "🚊"
    case 🚉 = "🚉"
    case 🚞 = "🚞"
    case 🚆 = "🚆"
    case 🚄 = "🚄"
    case 🚅 = "🚅"
    case 🚈 = "🚈"
    case 🚇 = "🚇"
    case 🚝 = "🚝"
    case 🚋 = "🚋"
    case 🚃 = "🚃"
    case 🚎 = "🚎"
    case 🚌 = "🚌"
    case 🚍 = "🚍"
    case 🚙 = "🚙"
    case 🚘 = "🚘"
    case 🚗 = "🚗"
    case 🚕 = "🚕"
    case 🚖 = "🚖"
    case 🚛 = "🚛"
    case 🚚 = "🚚"
    case 🚨 = "🚨"
    case 🚓 = "🚓"
    case 🚔 = "🚔"
    case 🚒 = "🚒"
    case 🚑 = "🚑"
    case 🚐 = "🚐"
    case 🚲 = "🚲"
    case 🚡 = "🚡"
    case 🚟 = "🚟"
    case 🚠 = "🚠"
    case 🚜 = "🚜"
    case 💈 = "💈"
    case 🚏 = "🚏"
    case 🎫 = "🎫"
    case 🚦 = "🚦"
    case 🚥 = "🚥"
    
    case 🚧 = "🚧"
    case 🔰 = "🔰"
    
    case 🏮 = "🏮"
    case 🎰 = "🎰"
    
    case 🗿 = "🗿"
    case 🎪 = "🎪"
    case 🎭 = "🎭"
    case 📍 = "📍"
    case 🚩 = "🚩"
    case 🇯 = "🇯"
    case 🇰 = "🇰"
    case 🇩 = "🇩"
    case 🇨 = "🇨"
    case 🇺 = "🇺"
    case 🇫 = "🇫"
    case 🇪 = "🇪"
    case 🇮 = "🇮"
    case 🇷 = "🇷"
}
/**
 case 1⃣ = "1⃣"
 case 2⃣ = "2⃣"
 case 3⃣ = "3⃣"
 case 4⃣ = "4⃣"
 case 5⃣ = "5⃣"
 case 6⃣ = "6⃣"
 case 7⃣ = "7⃣"
 case 8⃣ = "8⃣"
 case 9⃣ = "9⃣"
 case 0⃣ = "0⃣"
 
 case #⃣ = "#⃣"
 
 case ⬆ = "⬆"
 case ⬇ = "⬇"
 case ⬅ = "⬅"
 case ➡ = "➡"
 
 case ↗ = "↗"
 case ↖ = "↖"
 case ↘ = "↘"
 case ↙ = "↙"
 case ↔ = "↔"
 case ↕ = "↕"
 
 case ◀ = "◀"
 case ▶ = "▶"
 
 case ↩ = "↩"
 case ↪ = "↪"
 case ℹ = "ℹ"
 case ⏪ = "⏪"
 case ⏩ = "⏩"
 case ⏫ = "⏫"
 case ⏬ = "⏬"
 case ⤵ = "⤵"
 case ⤴ = "⤴"
 
 case ♿ = "♿"
 
 case ⛔ = "⛔"
 case ✳ = "✳"
 case ❇ = "❇"
 case ❎ = "❎"
 case ✅ = "✅"
 case ✴ = "✴"
 
 case ➿ = "➿"
 case ♻ = "♻"
 case ♈ = "♈"
 case ♉ = "♉"
 case ♊ = "♊"
 case ♋ = "♋"
 case ♌ = "♌"
 case ♍ = "♍"
 case ♎ = "♎"
 case ♏ = "♏"
 case ♐ = "♐"
 case ♑ = "♑"
 case ♒ = "♒"
 case ♓ = "♓"
 case ⛎ = "⛎"
 
 case © = "©"
 case ® = "®"
 case ™ = "™"
 case ❌ = "❌"
 case ‼ = "‼"
 case ⁉ = "⁉"
 case ❗ = "❗"
 case ❓ = "❓"
 case ❕ = "❕"
 case ❔ = "❔"
 case ⭕ = "⭕"
 
 case ✖ = "✖"
 case ➕ = "➕"
 case ➖ = "➖"
 case ➗ = "➗"
 case ♠ = "♠"
 case ♥ = "♥"
 case ♣ = "♣"
 case ♦ = "♦"
 
 case ✔ = "✔"
 case ☑ = "☑"
 
 case ➰ = "➰"
 case 〰 = "〰"
 
 case ◼ = "◼"
 case ◻ = "◻"
 case ◾ = "◾"
 case ◽ = "◽"
 case ▪ = "▪"
 case ▫ = "▫"
 
 case ⚫ = "⚫"
 case ⚪ = "⚪"
 
 case ⬜ = "⬜"
 case ⬛ = "⬛"
 */
enum SymbolEmoji: Character {
    case 🔟 = "🔟"
    case 🔢 = "🔢"
    
    case 🔣 = "🔣"
    
    case 🔠 = "🔠"
    case 🔡 = "🔡"
    case 🔤 = "🔤"
    
    case 🔄 = "🔄"
    
    case 🔼 = "🔼"
    case 🔽 = "🔽"
    
    case 🆗 = "🆗"
    case 🔀 = "🔀"
    case 🔁 = "🔁"
    case 🔂 = "🔂"
    case 🆕 = "🆕"
    case 🆙 = "🆙"
    case 🆒 = "🆒"
    case 🆓 = "🆓"
    case 🆖 = "🆖"
    case 📶 = "📶"
    case 🎦 = "🎦"
    case 🈁 = "🈁"
    case 🈯 = "🈯"
    case 🈳 = "🈳"
    case 🈵 = "🈵"
    case 🈴 = "🈴"
    case 🈲 = "🈲"
    case 🉐 = "🉐"
    case 🈹 = "🈹"
    case 🈺 = "🈺"
    case 🈶 = "🈶"
    case 🈚 = "🈚"
    case 🚻 = "🚻"
    case 🚹 = "🚹"
    case 🚺 = "🚺"
    case 🚼 = "🚼"
    case 🚾 = "🚾"
    case 🚰 = "🚰"
    case 🚮 = "🚮"
    case 🅿 = "🅿"
    
    case 🚭 = "🚭"
    case 🈷 = "🈷"
    case 🈸 = "🈸"
    case 🈂 = "🈂"
    case Ⓜ = "Ⓜ"
    case 🛂 = "🛂"
    case 🛄 = "🛄"
    case 🛅 = "🛅"
    case 🛃 = "🛃"
    case 🉑 = "🉑"
    case ㊙ = "㊙"
    case ㊗ = "㊗"
    case 🆑 = "🆑"
    case 🆘 = "🆘"
    case 🆔 = "🆔"
    case 🚫 = "🚫"
    case 🔞 = "🔞"
    case 📵 = "📵"
    case 🚯 = "🚯"
    case 🚱 = "🚱"
    case 🚳 = "🚳"
    case 🚷 = "🚷"
    case 🚸 = "🚸"
    
    case 💟 = "💟"
    case 🆚 = "🆚"
    case 📳 = "📳"
    case 📴 = "📴"
    case 🅰 = "🅰"
    case 🅱 = "🅱"
    case 🆎 = "🆎"
    case 🅾 = "🅾"
    case 💠 = "💠"
    
    case 🔯 = "🔯"
    case 🏧 = "🏧"
    case 💹 = "💹"
    case 💲 = "💲"
    case 💱 = "💱"
    
    case 🔝 = "🔝"
    case 🔚 = "🔚"
    case 🔙 = "🔙"
    case 🔛 = "🔛"
    case 🔜 = "🔜"
    case 🔃 = "🔃"
    case 🕛 = "🕛"
    case 🕧 = "🕧"
    case 🕐 = "🕐"
    case 🕜 = "🕜"
    case 🕑 = "🕑"
    case 🕝 = "🕝"
    case 🕒 = "🕒"
    case 🕞 = "🕞"
    case 🕓 = "🕓"
    case 🕟 = "🕟"
    case 🕔 = "🕔"
    case 🕠 = "🕠"
    case 🕕 = "🕕"
    case 🕖 = "🕖"
    case 🕗 = "🕗"
    case 🕘 = "🕘"
    case 🕙 = "🕙"
    case 🕚 = "🕚"
    case 🕡 = "🕡"
    case 🕢 = "🕢"
    case 🕣 = "🕣"
    case 🕤 = "🕤"
    case 🕥 = "🕥"
    case 🕦 = "🕦"
    
    case 💮 = "💮"
    case 💯 = "💯"
    
    case 🔘 = "🔘"
    case 🔗 = "🔗"
    
    case 〽 = "〽"
    case 🔱 = "🔱"
    
    case 🔺 = "🔺"
    case 🔲 = "🔲"
    case 🔳 = "🔳"
    
    case 🔴 = "🔴"
    case 🔵 = "🔵"
    case 🔻 = "🔻"
    
    case 🔶 = "🔶"
    case 🔷 = "🔷"
    case 🔸 = "🔸"
    case 🔹 = "🔹"
}

enum KeyboardKey: Hashable {
    case digit(Digit)
    case letter(Letter)
    case special(SpecialCharacter, KeyboardPageIdentifier)
    case modifier(Modifier, KeyboardPageIdentifier)
    case changePage(Int, KeyboardPageIdentifier)
    case natureEmoji(NatureEmoji)
    case objectEmoji(ObjectEmoji)
    case peopleEmoji(PeopleEmoji)
    case placeEmoji(PlaceEmoji)
    case symbolEmoji(SymbolEmoji)
    
    var hashValue: Int {
        return toInt()
    }
    
    var hasOutput: Bool {
        switch self {
        case .modifier(.Space, _):
            return true
        case .modifier(.Enter, _):
            return true
        case .modifier(.CallService, _):
            return false
        case .modifier:
            return false
        case .changePage(_, _):
            return false
        default:
            return true
        }
    }
    
    var isCharacter: Bool {
        switch self {
        case .modifier(_, _):
            return false
        case .changePage(_, _):
            return false
        default:
            return true
        }
    }
    
    var isModifier: Bool {
        switch self {
        case .modifier(_, _):
            return true
        case .changePage(_, _):
            return true
        default:
            return false
        }
    }
    
    var isSpace: Bool {
        switch self {
        case .modifier(.Space, _):
            return true
        default:
            return false
        }
    }
    
    func toString() -> String {
        switch(self) {
        case .digit(let digit):
            return String(digit.rawValue)
        case .letter(let letter):
            return String(letter.rawValue)
        case .modifier(let string, let pageId):
            return "\(string.rawValue):\(pageId.rawValue)"
        case .special(let character, let pageId):
            return "\(character.rawValue):\(pageId.rawValue)"
        case .changePage(let page, _):
            return "Page: \(page)"
        case .natureEmoji(let natureEmoji):
            return String(natureEmoji.rawValue)
        case .objectEmoji(let objectEmoji):
            return String(objectEmoji.rawValue)
        case .peopleEmoji(let peopleEmoji):
            return String(peopleEmoji.rawValue)
        case .placeEmoji(let placeEmoji):
            return String(placeEmoji.rawValue)
        case .symbolEmoji(let symbolEmoji):
            return String(symbolEmoji.rawValue)
        }
    }
    
    func toInt() -> Int {
        switch(self) {
        case .digit(let character):
            return character.hashValue
        case .letter(let character):
            return character.hashValue
        case .modifier(let character, _):
            return character.hashValue
        case .special(let character, _):
            return character.hashValue
        case .changePage(let page, _):
            return page
        case .natureEmoji(let character):
            return character.hashValue
        case .objectEmoji(let character):
            return character.hashValue
        case .peopleEmoji(let character):
            return character.hashValue
        case .placeEmoji(let character):
            return character.hashValue
        case .symbolEmoji(let character):
            return character.hashValue
        }
    }
}

extension KeyboardKey: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return toString()
    }
    
    var debugDescription: String {
        return toString()
    }
}

extension KeyboardKey: Equatable {}

func ==(lhs: KeyboardKey, rhs: KeyboardKey) -> Bool {
    return lhs.toString() == rhs.toString()
}

enum ShiftState {
    case Disabled
    case Enabled
    case Locked
    
    func lettercase() -> Lettercase {
        switch self {
        case Disabled:
            return .Lowercase
        case Enabled:
            return .Uppercase
        case Locked:
            return .Uppercase
        }
    }
    
    func uppercase() -> Bool {
        switch self {
        case Disabled:
            return false
        case Enabled:
            return true
        case Locked:
            return true
        }
    }
}

enum Lettercase {
    case Lowercase
    case Uppercase
}