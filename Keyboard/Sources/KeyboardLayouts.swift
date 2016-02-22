//
//  KeyboardMaps.swift
//  October
//
//  Created by Luc Succes on 7/15/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//
//  swiftlint:disable line_length

import Foundation

// CharacterMaps
private let EnglishKeyboardMap: [KeyboardRow] = [
    [.letter(.Q), .letter(.W), .letter(.E), .letter(.R), .letter(.T), .letter(.Y), .letter(.U), .letter(.I), .letter(.O), .letter(.P)],
    [.letter(.A), .letter(.S), .letter(.D), .letter(.F), .letter(.G), .letter(.H), .letter(.J), .letter(.K), .letter(.L)],
    [.modifier(.CapsLock, .Letter), .letter(.Z), .letter(.X), .letter(.C), .letter(.V), .letter(.B), .letter(.N), .letter(.M), .modifier(.Backspace, .Letter)],

        [.changePage(1, .Letter), .modifier(.SwitchKeyboard, .Letter), .modifier(.Share, .Letter), .modifier(.Space, .Letter), .modifier(.Enter, .Letter)]
]

private let NatureEmojiKeyboardMap: [KeyboardRow] = [
[.natureEmoji(.🐶),.natureEmoji(.🐺),.natureEmoji(.🐱),.natureEmoji(.🐭),.natureEmoji(.🐹),.natureEmoji(.🐰),.natureEmoji(.🐸)],
[.natureEmoji(.🐯),.natureEmoji(.🐨),.natureEmoji(.🐻),.natureEmoji(.🐷),.natureEmoji(.🐽),.natureEmoji(.🐮),.natureEmoji(.🐗)],
[.natureEmoji(.🐵),.natureEmoji(.🐒),.natureEmoji(.🐴),.natureEmoji(.🐑),.natureEmoji(.🐘),.natureEmoji(.🐼),.natureEmoji(.🐧)],
[.natureEmoji(.🐦),.natureEmoji(.🐤),.natureEmoji(.🐥),.natureEmoji(.🐣),.natureEmoji(.🐔),.natureEmoji(.🐍),.natureEmoji(.🐢)],
[.natureEmoji(.🐛),.natureEmoji(.🐝),.natureEmoji(.🐜),.natureEmoji(.🐞),.natureEmoji(.🐌),.natureEmoji(.🐙),.natureEmoji(.🐚)],
[.natureEmoji(.🐠),.natureEmoji(.🐟),.natureEmoji(.🐬),.natureEmoji(.🐳),.natureEmoji(.🐋),.natureEmoji(.🐄),.natureEmoji(.🐏)],
[.natureEmoji(.🐀),.natureEmoji(.🐃),.natureEmoji(.🐅),.natureEmoji(.🐇),.natureEmoji(.🐉),.natureEmoji(.🐎),.natureEmoji(.🐐)],
[.natureEmoji(.🐓),.natureEmoji(.🐕),.natureEmoji(.🐖),.natureEmoji(.🐁),.natureEmoji(.🐂),.natureEmoji(.🐲),.natureEmoji(.🐡)],
[.natureEmoji(.🐊),.natureEmoji(.🐫),.natureEmoji(.🐪),.natureEmoji(.🐆),.natureEmoji(.🐈),.natureEmoji(.🐩),.natureEmoji(.🐾)],
[.natureEmoji(.💐),.natureEmoji(.🌸),.natureEmoji(.🌷),.natureEmoji(.🍀),.natureEmoji(.🌹),.natureEmoji(.🌻),.natureEmoji(.🌺)],
[.natureEmoji(.🍁),.natureEmoji(.🍃),.natureEmoji(.🍂),.natureEmoji(.🌿),.natureEmoji(.🌾),.natureEmoji(.🍄),.natureEmoji(.🌵)],
[.natureEmoji(.🌴),.natureEmoji(.🌲),.natureEmoji(.🌳),.natureEmoji(.🌰),.natureEmoji(.🌱),.natureEmoji(.🌼),.natureEmoji(.🌐)],
[.natureEmoji(.🌞),.natureEmoji(.🌝),.natureEmoji(.🌚),.natureEmoji(.🌑),.natureEmoji(.🌒),.natureEmoji(.🌓),.natureEmoji(.🌔)],
[.natureEmoji(.🌕),.natureEmoji(.🌖),.natureEmoji(.🌗),.natureEmoji(.🌘),.natureEmoji(.🌜),.natureEmoji(.🌛),.natureEmoji(.🌙)],
[.natureEmoji(.🌍),.natureEmoji(.🌎),.natureEmoji(.🌏),.natureEmoji(.🌋),.natureEmoji(.🌌),.natureEmoji(.🌠),.natureEmoji(.🌀)],
[.natureEmoji(.🌁),.natureEmoji(.🌈),.natureEmoji(.🌊)]
]

private let ObjectEmojiKeyboardMap: [KeyboardRow] = [
    [.objectEmoji(.🎍),.objectEmoji(.💝),.objectEmoji(.🎎),.objectEmoji(.🎒),.objectEmoji(.🎓),.objectEmoji(.🎏),.objectEmoji(.🎆)],
    [.objectEmoji(.🎇),.objectEmoji(.🎐),.objectEmoji(.🎑),.objectEmoji(.🎃),.objectEmoji(.👻),.objectEmoji(.🎅),.objectEmoji(.🎄)],
    [.objectEmoji(.🎁),.objectEmoji(.🎋),.objectEmoji(.🎉),.objectEmoji(.🎊),.objectEmoji(.🎈),.objectEmoji(.🎌),.objectEmoji(.🔮)],
    [.objectEmoji(.🎥),.objectEmoji(.📷),.objectEmoji(.📹),.objectEmoji(.📼),.objectEmoji(.💿),.objectEmoji(.📀),.objectEmoji(.💽)],
    [.objectEmoji(.💾),.objectEmoji(.💻),.objectEmoji(.📱),.objectEmoji(.📞),.objectEmoji(.📟),.objectEmoji(.📠),.objectEmoji(.📡)],
    [.objectEmoji(.📺),.objectEmoji(.📻),.objectEmoji(.🔊),.objectEmoji(.🔉),.objectEmoji(.🔈),.objectEmoji(.🔇),.objectEmoji(.🔔)],
    [.objectEmoji(.🔕),.objectEmoji(.📢),.objectEmoji(.📣),.objectEmoji(.🔓),.objectEmoji(.🔒),.objectEmoji(.🔏),.objectEmoji(.🔐)],
    [.objectEmoji(.🔑),.objectEmoji(.🔎),.objectEmoji(.💡),.objectEmoji(.🔦),.objectEmoji(.🔆),.objectEmoji(.🔅),.objectEmoji(.🔌)],
    [.objectEmoji(.🔋),.objectEmoji(.🔍),.objectEmoji(.🛁),.objectEmoji(.🛀),.objectEmoji(.🚿),.objectEmoji(.🚽),.objectEmoji(.🔧)],
    [.objectEmoji(.🔩),.objectEmoji(.🔨),.objectEmoji(.🚪),.objectEmoji(.🚬),.objectEmoji(.💣),.objectEmoji(.🔫),.objectEmoji(.🔪)],
    [.objectEmoji(.💊),.objectEmoji(.💉),.objectEmoji(.💰),.objectEmoji(.💴),.objectEmoji(.💵),.objectEmoji(.💷),.objectEmoji(.💶)],
    [.objectEmoji(.💳),.objectEmoji(.💸),.objectEmoji(.📲),.objectEmoji(.📧),.objectEmoji(.📥),.objectEmoji(.📤),.objectEmoji(.📩)],
    [.objectEmoji(.📨),.objectEmoji(.📯),.objectEmoji(.📫),.objectEmoji(.📪),.objectEmoji(.📬),.objectEmoji(.📭),.objectEmoji(.📮)],
    [.objectEmoji(.📦),.objectEmoji(.📝),.objectEmoji(.📄),.objectEmoji(.📃),.objectEmoji(.📑),.objectEmoji(.📊),.objectEmoji(.📈)],
    [.objectEmoji(.📉),.objectEmoji(.📜),.objectEmoji(.📋),.objectEmoji(.📅),.objectEmoji(.📆),.objectEmoji(.📇),.objectEmoji(.📁)],
    [.objectEmoji(.📂),.objectEmoji(.📌),.objectEmoji(.📎),.objectEmoji(.📏),.objectEmoji(.📐),.objectEmoji(.📕),.objectEmoji(.📗)],
    [.objectEmoji(.📘),.objectEmoji(.📙),.objectEmoji(.📓),.objectEmoji(.📔),.objectEmoji(.📒),.objectEmoji(.📚),.objectEmoji(.📖)],
    [.objectEmoji(.🔖),.objectEmoji(.📛),.objectEmoji(.🔬),.objectEmoji(.🔭),.objectEmoji(.📰),.objectEmoji(.🎨),.objectEmoji(.🎬)],
    [.objectEmoji(.🎤),.objectEmoji(.🎧),.objectEmoji(.🎼),.objectEmoji(.🎵),.objectEmoji(.🎶),.objectEmoji(.🎹),.objectEmoji(.🎻)],
    [.objectEmoji(.🎺),.objectEmoji(.🎷),.objectEmoji(.🎸),.objectEmoji(.👾),.objectEmoji(.🎮),.objectEmoji(.🃏),.objectEmoji(.🎴)],
    [.objectEmoji(.🀄),.objectEmoji(.🎲),.objectEmoji(.🎯),.objectEmoji(.🏈),.objectEmoji(.🏀),.objectEmoji(.🎾),.objectEmoji(.🎱)],
    [.objectEmoji(.🏉),.objectEmoji(.🎳), .objectEmoji(.🚵),.objectEmoji(.🚴),.objectEmoji(.🏁),.objectEmoji(.🏇),.objectEmoji(.🏆)],
    [.objectEmoji(.🎿),.objectEmoji(.🏂),.objectEmoji(.🏊),.objectEmoji(.🏄),.objectEmoji(.🎣),.objectEmoji(.🍵),.objectEmoji(.🍶)],
    [.objectEmoji(.🍼),.objectEmoji(.🍺),.objectEmoji(.🍻),.objectEmoji(.🍸),.objectEmoji(.🍹),.objectEmoji(.🍷),.objectEmoji(.🍴)],
    [.objectEmoji(.🍕),.objectEmoji(.🍔),.objectEmoji(.🍟),.objectEmoji(.🍗),.objectEmoji(.🍖),.objectEmoji(.🍝),.objectEmoji(.🍛)],
    [.objectEmoji(.🍤),.objectEmoji(.🍱),.objectEmoji(.🍣),.objectEmoji(.🍥),.objectEmoji(.🍙),.objectEmoji(.🍘),.objectEmoji(.🍚)],
    [.objectEmoji(.🍜),.objectEmoji(.🍲),.objectEmoji(.🍢),.objectEmoji(.🍡),.objectEmoji(.🍳),.objectEmoji(.🍞),.objectEmoji(.🍩)],
    [.objectEmoji(.🍮),.objectEmoji(.🍦),.objectEmoji(.🍨),.objectEmoji(.🍧),.objectEmoji(.🎂),.objectEmoji(.🍰),.objectEmoji(.🍪)],
    [.objectEmoji(.🍫),.objectEmoji(.🍬),.objectEmoji(.🍭),.objectEmoji(.🍯),.objectEmoji(.🍎),.objectEmoji(.🍏),.objectEmoji(.🍊)],
    [.objectEmoji(.🍋),.objectEmoji(.🍒),.objectEmoji(.🍇),.objectEmoji(.🍉),.objectEmoji(.🍓),.objectEmoji(.🍑),.objectEmoji(.🍈)],
    [.objectEmoji(.🍌),.objectEmoji(.🍐),.objectEmoji(.🍍),.objectEmoji(.🍠),.objectEmoji(.🍆),.objectEmoji(.🍅),.objectEmoji(.🌽)]
]

private let PeopleEmojiKeyboardMap: [KeyboardRow] = [
    [.peopleEmoji(.😄),.peopleEmoji(.😃),.peopleEmoji(.😀),.peopleEmoji(.😊),.peopleEmoji(.😉),.peopleEmoji(.😍),.peopleEmoji(.😘)],
    [.peopleEmoji(.😚),.peopleEmoji(.😗),.peopleEmoji(.😙),.peopleEmoji(.😜),.peopleEmoji(.😝),.peopleEmoji(.😛),.peopleEmoji(.😳)],
    [.peopleEmoji(.😁),.peopleEmoji(.😔),.peopleEmoji(.😌),.peopleEmoji(.😒),.peopleEmoji(.😞),.peopleEmoji(.😣),.peopleEmoji(.😢)],
    [.peopleEmoji(.😂),.peopleEmoji(.😭),.peopleEmoji(.😪),.peopleEmoji(.😥),.peopleEmoji(.😰),.peopleEmoji(.😅),.peopleEmoji(.😓)],
    [.peopleEmoji(.😩),.peopleEmoji(.😫),.peopleEmoji(.😨),.peopleEmoji(.😱),.peopleEmoji(.😠),.peopleEmoji(.😡),.peopleEmoji(.😤)],
    [.peopleEmoji(.😖),.peopleEmoji(.😆),.peopleEmoji(.😋),.peopleEmoji(.😷),.peopleEmoji(.😎),.peopleEmoji(.😴),.peopleEmoji(.😵)],
    [.peopleEmoji(.😲),.peopleEmoji(.😟),.peopleEmoji(.😦),.peopleEmoji(.😧),.peopleEmoji(.😈),.peopleEmoji(.👿),.peopleEmoji(.😮)],
    [.peopleEmoji(.😬),.peopleEmoji(.😐),.peopleEmoji(.😕),.peopleEmoji(.😯),.peopleEmoji(.😶),.peopleEmoji(.😇),.peopleEmoji(.😏)],
    [.peopleEmoji(.😑),.peopleEmoji(.👲),.peopleEmoji(.👳),.peopleEmoji(.👮),.peopleEmoji(.👷),.peopleEmoji(.💂),.peopleEmoji(.👶)],
    [.peopleEmoji(.👦),.peopleEmoji(.👧),.peopleEmoji(.👨),.peopleEmoji(.👩),.peopleEmoji(.👴),.peopleEmoji(.👵),.peopleEmoji(.👱)],
    [.peopleEmoji(.👼),.peopleEmoji(.👸),.peopleEmoji(.😺),.peopleEmoji(.😸),.peopleEmoji(.😻),.peopleEmoji(.😽),.peopleEmoji(.😼)],
    [.peopleEmoji(.🙀),.peopleEmoji(.😿),.peopleEmoji(.😹),.peopleEmoji(.😾),.peopleEmoji(.👹),.peopleEmoji(.👺),.peopleEmoji(.🙈)],
    [.peopleEmoji(.🙉),.peopleEmoji(.🙊),.peopleEmoji(.💀),.peopleEmoji(.👽),.peopleEmoji(.💩),.peopleEmoji(.🔥),.peopleEmoji(.🌟)],
    [.peopleEmoji(.💫),.peopleEmoji(.💥),.peopleEmoji(.💢),.peopleEmoji(.💦),.peopleEmoji(.💧),.peopleEmoji(.💤),.peopleEmoji(.💨)],
    [.peopleEmoji(.👂),.peopleEmoji(.👀),.peopleEmoji(.👃),.peopleEmoji(.👅),.peopleEmoji(.👄),.peopleEmoji(.👍),.peopleEmoji(.👎)],
    [.peopleEmoji(.👌),.peopleEmoji(.👊),.peopleEmoji(.👋),.peopleEmoji(.👐),.peopleEmoji(.👆),.peopleEmoji(.👇),.peopleEmoji(.👉)],
    [.peopleEmoji(.👈),.peopleEmoji(.🙌),.peopleEmoji(.🙏),.peopleEmoji(.👏),.peopleEmoji(.💪),.peopleEmoji(.🚶),.peopleEmoji(.🏃)],
    [.peopleEmoji(.💃),.peopleEmoji(.👫),.peopleEmoji(.👪),.peopleEmoji(.👬),.peopleEmoji(.👭),.peopleEmoji(.💏),.peopleEmoji(.💑)],
    [.peopleEmoji(.👯),.peopleEmoji(.🙆),.peopleEmoji(.🙅),.peopleEmoji(.💁),.peopleEmoji(.🙋),.peopleEmoji(.💆),.peopleEmoji(.💇)],
    [.peopleEmoji(.💅),.peopleEmoji(.👰),.peopleEmoji(.🙎),.peopleEmoji(.🙍),.peopleEmoji(.🙇),.peopleEmoji(.🎩),.peopleEmoji(.👑)],
    [.peopleEmoji(.👒),.peopleEmoji(.👟),.peopleEmoji(.👞),.peopleEmoji(.👡),.peopleEmoji(.👠),.peopleEmoji(.👢),.peopleEmoji(.👕)],
    [.peopleEmoji(.👔),.peopleEmoji(.👚),.peopleEmoji(.👗),.peopleEmoji(.🎽),.peopleEmoji(.👖),.peopleEmoji(.👘),.peopleEmoji(.👙)],
    [.peopleEmoji(.💼),.peopleEmoji(.👜),.peopleEmoji(.👝),.peopleEmoji(.👛),.peopleEmoji(.👓),.peopleEmoji(.🎀),.peopleEmoji(.🌂)],
    [.peopleEmoji(.💄),.peopleEmoji(.💛),.peopleEmoji(.💙),.peopleEmoji(.💜),.peopleEmoji(.💚),.peopleEmoji(.💔),.peopleEmoji(.💗)],
    [.peopleEmoji(.💓),.peopleEmoji(.💕),.peopleEmoji(.💖),.peopleEmoji(.💞),.peopleEmoji(.💘),.peopleEmoji(.💌),.peopleEmoji(.💋)],
    [.peopleEmoji(.💍),.peopleEmoji(.💎),.peopleEmoji(.👤),.peopleEmoji(.👥),.peopleEmoji(.💬),.peopleEmoji(.👣),.peopleEmoji(.💭)]
]

private let PlaceEmojiKeyboardMap: [KeyboardRow] = [
    [.placeEmoji(.🏠),.placeEmoji(.🏡),.placeEmoji(.🏫),.placeEmoji(.🏢),.placeEmoji(.🏣),.placeEmoji(.🏥),.placeEmoji(.🏦)],
    [.placeEmoji(.🏪),.placeEmoji(.🏩),.placeEmoji(.🏨),.placeEmoji(.💒),.placeEmoji(.🏬),.placeEmoji(.🏤),.placeEmoji(.🌇)],
    [.placeEmoji(.🌆),.placeEmoji(.🏯),.placeEmoji(.🏰),.placeEmoji(.🏭),.placeEmoji(.🗼),.placeEmoji(.🗾),.placeEmoji(.🗻)],
    [.placeEmoji(.🌄),.placeEmoji(.🌅),.placeEmoji(.🌃),.placeEmoji(.🗽),.placeEmoji(.🌉),.placeEmoji(.🎠),.placeEmoji(.🎡)],
    [.placeEmoji(.🎢),.placeEmoji(.🚢),.placeEmoji(.🚤),.placeEmoji(.🚣),.placeEmoji(.🚀),.placeEmoji(.💺),.placeEmoji(.🚁)],
    [.placeEmoji(.🚂),.placeEmoji(.🚊),.placeEmoji(.🚉),.placeEmoji(.🚞),.placeEmoji(.🚆),.placeEmoji(.🚄),.placeEmoji(.🚅)],
    [.placeEmoji(.🚈),.placeEmoji(.🚇),.placeEmoji(.🚝),.placeEmoji(.🚋),.placeEmoji(.🚃),.placeEmoji(.🚎),.placeEmoji(.🚌)],
    [.placeEmoji(.🚍),.placeEmoji(.🚙),.placeEmoji(.🚘),.placeEmoji(.🚗),.placeEmoji(.🚕),.placeEmoji(.🚖),.placeEmoji(.🚛)],
    [.placeEmoji(.🚚),.placeEmoji(.🚨),.placeEmoji(.🚓),.placeEmoji(.🚔),.placeEmoji(.🚒),.placeEmoji(.🚑),.placeEmoji(.🚐)],
    [.placeEmoji(.🚲),.placeEmoji(.🚡),.placeEmoji(.🚟),.placeEmoji(.🚠),.placeEmoji(.🚜),.placeEmoji(.💈),.placeEmoji(.🚏)],
    [.placeEmoji(.🎫),.placeEmoji(.🚦),.placeEmoji(.🚥),.placeEmoji(.🚧),.placeEmoji(.🔰),.placeEmoji(.🏮),.placeEmoji(.🎰)],
    [.placeEmoji(.🗿),.placeEmoji(.🎪),.placeEmoji(.🎭),.placeEmoji(.📍),.placeEmoji(.🚩),.placeEmoji(.🇯),.placeEmoji(.🇰)],
    [.placeEmoji(.🇩),.placeEmoji(.🇨),.placeEmoji(.🇺),.placeEmoji(.🇫),.placeEmoji(.🇪),.placeEmoji(.🇮),.placeEmoji(.🇷)]
]

private let SymbolEmojiKeyboardMap: [KeyboardRow] = [
    [.symbolEmoji(.🔟),.symbolEmoji(.🔢),.symbolEmoji(.🔣),.symbolEmoji(.🔠),.symbolEmoji(.🔡),.symbolEmoji(.🔤),.symbolEmoji(.🔄)],
    [.symbolEmoji(.🔼),.symbolEmoji(.🔽),.symbolEmoji(.🆗),.symbolEmoji(.🔀),.symbolEmoji(.🔁),.symbolEmoji(.🔂),.symbolEmoji(.🆕)],
    [.symbolEmoji(.🆙),.symbolEmoji(.🆒),.symbolEmoji(.🆓),.symbolEmoji(.🆖),.symbolEmoji(.📶),.symbolEmoji(.🎦),.symbolEmoji(.🈁)],
    [.symbolEmoji(.🈯),.symbolEmoji(.🈳),.symbolEmoji(.🈵),.symbolEmoji(.🈴),.symbolEmoji(.🈲),.symbolEmoji(.🉐),.symbolEmoji(.🈹)],
    [.symbolEmoji(.🈺),.symbolEmoji(.🈶),.symbolEmoji(.🈚),.symbolEmoji(.🚻),.symbolEmoji(.🚹),.symbolEmoji(.🚺),.symbolEmoji(.🚼)],
    [.symbolEmoji(.🚾),.symbolEmoji(.🚰),.symbolEmoji(.🚮),.symbolEmoji(.🅿),.symbolEmoji(.🚭),.symbolEmoji(.🈷),.symbolEmoji(.🈸)],
    [.symbolEmoji(.🈂),.symbolEmoji(.Ⓜ),.symbolEmoji(.🛂),.symbolEmoji(.🛄),.symbolEmoji(.🛅),.symbolEmoji(.🛃),.symbolEmoji(.🉑)],
    [.symbolEmoji(.㊙),.symbolEmoji(.㊗),.symbolEmoji(.🆑),.symbolEmoji(.🆘),.symbolEmoji(.🆔),.symbolEmoji(.🚫),.symbolEmoji(.🔞)],
    [.symbolEmoji(.📵),.symbolEmoji(.🚯),.symbolEmoji(.🚱),.symbolEmoji(.🚳),.symbolEmoji(.🚷),.symbolEmoji(.🚸),.symbolEmoji(.💟)],
    [.symbolEmoji(.🆚),.symbolEmoji(.📳),.symbolEmoji(.📴),.symbolEmoji(.🅰),.symbolEmoji(.🅱),.symbolEmoji(.🆎),.symbolEmoji(.🅾)],
    [.symbolEmoji(.💠),.symbolEmoji(.🔯),.symbolEmoji(.🏧),.symbolEmoji(.💹),.symbolEmoji(.💲),.symbolEmoji(.💱),.symbolEmoji(.🔝)],
    [.symbolEmoji(.🔚),.symbolEmoji(.🔛),.symbolEmoji(.🔜),.symbolEmoji(.🔃),.symbolEmoji(.🕛),.symbolEmoji(.🕧),.symbolEmoji(.🕐)],
    [.symbolEmoji(.🕜),.symbolEmoji(.🕑),.symbolEmoji(.🕝),.symbolEmoji(.🕒),.symbolEmoji(.🕞),.symbolEmoji(.🕓),.symbolEmoji(.🕟)],
    [.symbolEmoji(.🕔),.symbolEmoji(.🕠),.symbolEmoji(.🕕),.symbolEmoji(.🕖),.symbolEmoji(.🕗),.symbolEmoji(.🕘),.symbolEmoji(.🕙)],
    [.symbolEmoji(.🕚),.symbolEmoji(.🕡),.symbolEmoji(.🕢),.symbolEmoji(.🕣),.symbolEmoji(.🕤),.symbolEmoji(.🕥),.symbolEmoji(.🕦)],
    [.symbolEmoji(.💮),.symbolEmoji(.💯),.symbolEmoji(.🔘),.symbolEmoji(.🔗),.symbolEmoji(.〽),.symbolEmoji(.🔱),.symbolEmoji(.🔺)],
    [.symbolEmoji(.🔲),.symbolEmoji(.🔳),.symbolEmoji(.🔴),.symbolEmoji(.🔵),.symbolEmoji(.🔻),.symbolEmoji(.🔶),.symbolEmoji(.🔷)],
    [.symbolEmoji(.🔸),.symbolEmoji(.🔹)]
]

private let SpecialCharacterKeyboardMap: [KeyboardRow] = [
    [.digit(.One), .digit(.Two), .digit(.Three), .digit(.Four), .digit(.Five), .digit(.Six), .digit(.Seven), .digit(.Eight), .digit(.Nine), .digit(.Zero)],
    [.special(.Hyphen, .Special), .special(.Slash, .Special), .special(.Colon, .Special), .special(.Semicolon, .Special), .special(.OpenParenthesis, .Special), .special(.CloseParenthesis, .Special), .special(.DollarSign, .Special), .special(.Ampersand, .Special), .special(.At, .Special), .special(.Quote, .Special)],
    [.changePage(2, .Special), .special(.Period, .Special), .special(.Comma, .Special), .special(.QuestionMark, .Special), .special(.ExclamationMark, .Special), .special(.SingleQuote, .Special), .modifier(.Backspace, .Special)],

        [.changePage(0, .Special), .modifier(.SwitchKeyboard, .Letter), .modifier(.Share, .Letter), .modifier(.Space, .Letter), .modifier(.Enter, .Letter)]
]

private let NextSpecialCharacterKeyboardMap: [KeyboardRow] = [
    [.special(.OpenBracket, .SecondSpecial), .special(.CloseBracket, .SecondSpecial), .special(.OpenBrace, .SecondSpecial), .special(.CloseBrace, .SecondSpecial), .special(.Hashtag, .SecondSpecial), .special(.Percent, .SecondSpecial), .special(.Caret, .SecondSpecial), .special(.Asterisk, .SecondSpecial), .special(.Plus, .SecondSpecial), .special(.Equal, .SecondSpecial)],
    [.special(.Underscore, .SecondSpecial), .special(.Backslash, .SecondSpecial), .special(.Line, .SecondSpecial), .special(.Tilda, .SecondSpecial), .special(.LessThan, .SecondSpecial), .special(.GreaterThan, .SecondSpecial), .special(.Euro, .SecondSpecial), .special(.PoundSterling, .SecondSpecial), .special(.Dot, .SecondSpecial)],
    [.changePage(1, .SecondSpecial), .special(.Period, .SecondSpecial), .special(.Comma, .SecondSpecial), .special(.QuestionMark, .SecondSpecial), .special(.ExclamationMark, .SecondSpecial), .special(.SingleQuote, .SecondSpecial), .modifier(.Backspace, .SecondSpecial)],

    [.changePage(1, .SecondSpecial), .modifier(.SwitchKeyboard, .Letter), .modifier(.Share, .Letter), .modifier(.Space, .Letter), .modifier(.Enter, .Letter)]
]

enum Language: String {
    case English = "en_US"
    case Emoji = "emoji"
}

let KeyboardLayouts: [Language: KeyboardLayout] = [
    .English: KeyboardLayout(locale: Language.English.rawValue, pages: [
        KeyboardPage(id: .Letter, rows: EnglishKeyboardMap),
        KeyboardPage(id: .Special, rows: SpecialCharacterKeyboardMap),
        KeyboardPage(id: .SecondSpecial, rows: NextSpecialCharacterKeyboardMap)
    ]),
    
    .Emoji: KeyboardLayout(locale: Language.Emoji.rawValue, pages: [
        KeyboardPage(id: .Emoji, rows: NatureEmojiKeyboardMap),
        KeyboardPage(id: .Emoji, rows: ObjectEmojiKeyboardMap),
        KeyboardPage(id: .Emoji, rows: PeopleEmojiKeyboardMap),
        KeyboardPage(id: .Emoji, rows: PlaceEmojiKeyboardMap),
        KeyboardPage(id: .Emoji, rows: SymbolEmojiKeyboardMap)
    ])
]

var DefaultKeyboardLayout = KeyboardLayouts[.English]!
