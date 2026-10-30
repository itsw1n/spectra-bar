.pragma library

var background = "#050a13"
var segment = "#0a121f"
var focusSegment = "#0c1727"
var badge = "#0d1b2c"
var border = "#536884"
var accent = "#afcaff"
var muted = "#91a3bc"
var barHeight = 32
var segmentHeight = 26
var badgeHeight = 32
var chamfer = 8
var badgeChamfer = 13
var outerPadding = 8
var connectionGap = 2

function badgeWidth(screenWidth) {
  return Math.max(68, Math.min(110, Math.round(screenWidth * 0.05)))
}

function sectionWidth(screenWidth, role) {
  var remaining = screenWidth - outerPadding * 2 - connectionGap * 2 - badgeWidth(screenWidth)
  return Math.max(0, Math.round(remaining * ((role === "left" || role === "right") ? 0.32 : 0.18)))
}
