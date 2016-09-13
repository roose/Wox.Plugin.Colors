import wox, colors, nimPNG, strutils, pegs, windows, os

const
  colorNames = [
    ("aliceblue", colAliceBlue),
    ("antiquewhite", colAntiqueWhite),
    ("aqua", colAqua),
    ("aquamarine", colAquamarine),
    ("azure", colAzure),
    ("beige", colBeige),
    ("bisque", colBisque),
    ("black", colBlack),
    ("blanchedalmond", colBlanchedAlmond),
    ("blue", colBlue),
    ("blueviolet", colBlueViolet),
    ("brown", colBrown),
    ("burlywood", colBurlyWood),
    ("cadetblue", colCadetBlue),
    ("chartreuse", colChartreuse),
    ("chocolate", colChocolate),
    ("coral", colCoral),
    ("cornflowerblue", colCornflowerBlue),
    ("cornsilk", colCornsilk),
    ("crimson", colCrimson),
    ("cyan", colCyan),
    ("darkblue", colDarkBlue),
    ("darkcyan", colDarkCyan),
    ("darkgoldenrod", colDarkGoldenRod),
    ("darkgray", colDarkGray),
    ("darkgreen", colDarkGreen),
    ("darkkhaki", colDarkKhaki),
    ("darkmagenta", colDarkMagenta),
    ("darkolivegreen", colDarkOliveGreen),
    ("darkorange", colDarkorange),
    ("darkorchid", colDarkOrchid),
    ("darkred", colDarkRed),
    ("darksalmon", colDarkSalmon),
    ("darkseagreen", colDarkSeaGreen),
    ("darkslateblue", colDarkSlateBlue),
    ("darkslategray", colDarkSlateGray),
    ("darkturquoise", colDarkTurquoise),
    ("darkviolet", colDarkViolet),
    ("deeppink", colDeepPink),
    ("deepskyblue", colDeepSkyBlue),
    ("dimgray", colDimGray),
    ("dodgerblue", colDodgerBlue),
    ("firebrick", colFireBrick),
    ("floralwhite", colFloralWhite),
    ("forestgreen", colForestGreen),
    ("fuchsia", colFuchsia),
    ("gainsboro", colGainsboro),
    ("ghostwhite", colGhostWhite),
    ("gold", colGold),
    ("goldenrod", colGoldenRod),
    ("gray", colGray),
    ("green", colGreen),
    ("greenyellow", colGreenYellow),
    ("honeydew", colHoneyDew),
    ("hotpink", colHotPink),
    ("indianred", colIndianRed),
    ("indigo", colIndigo),
    ("ivory", colIvory),
    ("khaki", colKhaki),
    ("lavender", colLavender),
    ("lavenderblush", colLavenderBlush),
    ("lawngreen", colLawnGreen),
    ("lemonchiffon", colLemonChiffon),
    ("lightblue", colLightBlue),
    ("lightcoral", colLightCoral),
    ("lightcyan", colLightCyan),
    ("lightgoldenrodyellow", colLightGoldenRodYellow),
    ("lightgrey", colLightGrey),
    ("lightgreen", colLightGreen),
    ("lightpink", colLightPink),
    ("lightsalmon", colLightSalmon),
    ("lightseagreen", colLightSeaGreen),
    ("lightskyblue", colLightSkyBlue),
    ("lightslategray", colLightSlateGray),
    ("lightsteelblue", colLightSteelBlue),
    ("lightyellow", colLightYellow),
    ("lime", colLime),
    ("limegreen", colLimeGreen),
    ("linen", colLinen),
    ("magenta", colMagenta),
    ("maroon", colMaroon),
    ("mediumaquamarine", colMediumAquaMarine),
    ("mediumblue", colMediumBlue),
    ("mediumorchid", colMediumOrchid),
    ("mediumpurple", colMediumPurple),
    ("mediumseagreen", colMediumSeaGreen),
    ("mediumslateblue", colMediumSlateBlue),
    ("mediumspringgreen", colMediumSpringGreen),
    ("mediumturquoise", colMediumTurquoise),
    ("mediumvioletred", colMediumVioletRed),
    ("midnightblue", colMidnightBlue),
    ("mintcream", colMintCream),
    ("mistyrose", colMistyRose),
    ("moccasin", colMoccasin),
    ("navajowhite", colNavajoWhite),
    ("navy", colNavy),
    ("oldlace", colOldLace),
    ("olive", colOlive),
    ("olivedrab", colOliveDrab),
    ("orange", colOrange),
    ("orangered", colOrangeRed),
    ("orchid", colOrchid),
    ("palegoldenrod", colPaleGoldenRod),
    ("palegreen", colPaleGreen),
    ("paleturquoise", colPaleTurquoise),
    ("palevioletred", colPaleVioletRed),
    ("papayawhip", colPapayaWhip),
    ("peachpuff", colPeachPuff),
    ("peru", colPeru),
    ("pink", colPink),
    ("plum", colPlum),
    ("powderblue", colPowderBlue),
    ("purple", colPurple),
    ("red", colRed),
    ("rosybrown", colRosyBrown),
    ("royalblue", colRoyalBlue),
    ("saddlebrown", colSaddleBrown),
    ("salmon", colSalmon),
    ("sandybrown", colSandyBrown),
    ("seagreen", colSeaGreen),
    ("seashell", colSeaShell),
    ("sienna", colSienna),
    ("silver", colSilver),
    ("skyblue", colSkyBlue),
    ("slateblue", colSlateBlue),
    ("slategray", colSlateGray),
    ("snow", colSnow),
    ("springgreen", colSpringGreen),
    ("steelblue", colSteelBlue),
    ("tan", colTan),
    ("teal", colTeal),
    ("thistle", colThistle),
    ("tomato", colTomato),
    ("turquoise", colTurquoise),
    ("violet", colViolet),
    ("wheat", colWheat),
    ("white", colWhite),
    ("whitesmoke", colWhiteSmoke),
    ("yellow", colYellow),
    ("yellowgreen", colYellowGreen)]

type
  WoxColor = object
    name: string
    color: string

proc normalizeHex(hex: string): string =
  # normalize a hex color to 6 digits
  result = "#"
  if hex.len == 3:
    for c in hex:
      result.add(c.repeat(2))
  else:
    result.add(hex)

proc parseHex(hex: string): tuple[r, g, b: int] =
  # convert hex to r, g, b
  let hex = normalizeHex(hex[1..^1])
  return extractRGB(colors.parseColor(hex))

proc parseRGB(rgb: string): tuple[r, g, b: int] =
  # convert rgb to r, g, b
  var elems = rgb.split(peg"[a-zA-Z ,();]+")
  return (parseInt(elems[0]), parseInt(elems[1]), parseInt(elems[2]))

proc parseName(name: string): tuple[r, g, b: int] =
  # convert color name to r, g, b
  return extractRGB(colors.parseColor(name))

proc parseColor(s: string): tuple[r, g, b: int] =
  # convert hex or rgb or color name to r, g, b
  if s.startsWith("#"):
    return parseHex(s)
  elif s.startsWith("rgb"):
    return parseRGB(s)
  elif isColor(s):
    return parseName(s)
  else:
    raise newException(ValueError, "unknown color: " & s)

proc rgbToHex(r, g, b: int): string =
  # get hex string from r, g, b
  return $rgb(r, g, b)

proc rgbToRGB(r, g, b: int): string =
  # get rgb string from r, g, b
  return join(["rgb(", $r, ",", $g, ",", $b, ")"])

proc rgbToName(r, g, b: int): string =
  # get color name string from r, g, b
  let rgb = rgb(r, g, b)
  for c in colorNames:
    if c[1] == rgb:
      return c[0]
  return "none"

proc colorList(color: string): seq[WoxColor] =
  # generate list of color types
  result = @[]
  var (r, g, b) = parseColor(color)
  result.add(WoxColor(name: "Hexademical", color: rgbToHex(r, g, b)))
  result.add(WoxColor(name: "RGB", color: rgbToRGB(r, g, b)))
  let name = rgbToName(r, g, b)
  if name != "none":
    result.add(WoxColor(name: "Name", color: name))

proc toClipboard(wp: Wox, params: varargs[string]) =
  let s = params[0]
  var
    sl = int32(s.len) + 1
    h = GlobalAlLoc(GMEM_FIXED, sl)
  copyMem(GlobalLock(h), cstring(s), sl)
  discard GlobalUnlock(h)
  discard OpenClipboard(0)
  discard EmptyClipboard()
  discard SetClipboardData(CF_TEXT, h)
  discard CloseClipboard()

proc createPng(wp: Wox, color: string): string =
  let
    path = joinPath([wp.cacheDir, color & ".png"])
    (r, g, b) = extractRGB(colors.parseColor(color))
    w = 32
    h = 32
  var data  = newString(w * h * 3)
  for y in 0..h-1:
    for x in 0..w-1:
      data[3 * w * y + 3 * x + 0] = chr(r)
      data[3 * w * y + 3 * x + 1] = chr(g)
      data[3 * w * y + 3 * x + 2] = chr(b)
  if not fileExists(path):
    discard savePNG24(path, data, w, h)

  return path

proc query(wp: Wox, params: varargs[string]) =
  let query = params[0].strip
  var valid = true
  var colors: seq[WoxColor]

  try:
    colors = colorList(query)
  except:
    valid = false

  if valid and query.len > 3:
    let ico = wp.createPng(colors[0].color)
    for color in colors:
      wp.add(color.color, color.name, ico, "toClipboard", color.color, false)
    echo wp.results()
  else:
    wp.add("No Results", "", "Images\\colors.png", "", "", true)
    echo wp.results()

when isMainModule:
  var wp = newWox()
  wp.register("query", query)
  wp.register("toClipboard", toClipboard)
  wp.run()
