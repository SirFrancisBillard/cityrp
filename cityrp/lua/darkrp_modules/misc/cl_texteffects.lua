
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawLine = surface.DrawLine
local draw_SimpleText = draw.SimpleText
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local string_Explode = string.Explode
local math_Rand = math.Rand
local math_random = math.random
local math_sin = math.sin
local math_abs = math.abs
local HSVtoColor = HSVToColor
local Realtime = RealTime
local Frametime = FrameTime
local Curtime = CurTime
local Color = Color

/*---------------------------------------------------------------------------
Align Text Helper
---------------------------------------------------------------------------*/
local function m_GetTextSize(text, font)
    surface_SetFont(font)
    return surface_GetTextSize(text)
end

local should_align_x = {[TEXT_ALIGN_CENTER] = true, [TEXT_ALIGN_RIGHT] = true}
local should_align_y = {[TEXT_ALIGN_BOTTOM] = true}
local function m_AlignText(text, font, x, y, xalign, yalign)
    local tw, th = m_GetTextSize(text, font)

    if (should_align_x[xalign]) then x = xalign == TEXT_ALIGN_CENTER and x - (tw / 2) or x - tw end
    if (should_align_y[yalign]) then y = y - th end

    return x, y
end

/*---------------------------------------------------------------------------
Color Transition Function
---------------------------------------------------------------------------*/

function GlowColor(c, t, m)
    return Color(c.r + ((t.r - c.r) * (m)), c.g + ((t.g - c.g) * (m)), c.b + ((t.b - c.b) * (m)))
end

/*---------------------------------------------------------------------------
Text Effect Functions
---------------------------------------------------------------------------*/

function DrawShadowedText(shadow, text, font, x, y, color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    draw_SimpleText(text, font, x + shadow, y + shadow, Color(0, 0, 0, color.a or 255), xalign, yalign)
    draw_SimpleText(text, font, x, y, color, xalign, yalign)
end

function DrawEnchantedText(speed, text, font, x, y, color, glow_color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    glow_color = glow_color or Color(127, 0, 255)

    local texte = string_Explode("", text)
    local chars_x = 0

    x, y = m_AlignText(text, font, x, y, xalign, yalign)
    surface_SetFont(font)

    for i = 1, #texte do
        local char = texte[i]
        local charw = surface_GetTextSize(char)
        local color_glowing = GlowColor(glow_color, color, math_abs(math_sin((Realtime() - (i * 0.08)) * speed)))
        draw_SimpleText(char, font, x + chars_x, y, color_glowing, xalign, yalign)

        chars_x = chars_x + charw
    end
end

function DrawFadingText(speed, text, font, x, y, color, fading_color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    fading_color = fading_color or Color(255, 255, 255)

    local c = GlowColor(color, fading_color, math_abs(math_sin((Realtime() - 0.08) * speed)))
    draw_SimpleText(text, font, x, y, c, xalign, yalign)
end

function DrawRainbowText(speed, text, font, x, y, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    draw_SimpleText(text, font, x, y, HSVtoColor(Curtime() * (70 * speed) % 360, 1, 1), xalign, yalign)
end

function DrawGlowingText(static, text, font, x, y, color, xalign, yalign)
    local xalign = xalign or TEXT_ALIGN_LEFT
    local yalign = yalign or TEXT_ALIGN_TOP
    local g = static and 1 or math_abs(math_sin((Realtime() - 0.1) * 2))

    for i = 1, 2 do -- You can change this if you want a heavier glow
        draw_SimpleTextOutlined(text, font, x, y, color, xalign, yalign, i, Color(color.r, color.g, color.b, (20 - (i * 5)) * g))
        -- first number (20) is the initial alpha of the glow, then the following number (5) is the amount at which the alpha declines for the glow
    end

    draw_SimpleText(text, font, x, y, color, xalign, yalign)
end

function DrawBouncingText(style, intesity, text, font, x, y, color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    local chars_x = 0
    local texte = string_Explode("", text)
    local x, y = m_AlignText(text, font, x, y, xalign, yalign)
    surface_SetFont(font)

    for i = 1, #texte do
        local char = texte[i]
        local charw = surface_GetTextSize(char)
        local y_pos = 1
        local mod = math_sin((Realtime() - (i * 0.1)) * (2 * intesity))

        if (style < 3) then
            y_pos = style == 1 and y_pos - math_abs(mod) or y_pos + math_abs(mod)
        else
            y_pos = y_pos - mod
        end

        draw_SimpleText(char, font, x + chars_x, y - (5 * y_pos), color, xalign, yalign) -- You can change the number (5) for a heavier impact
        chars_x = chars_x + charw
    end
end

local ne, ea = Curtime(), 0 -- next electric effect and current effect
function DrawElectricText(intensity, text, font, x, y, color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    draw_SimpleText(text, font, x, y, color, xalign, yalign)

    local charw, charh = m_GetTextSize(text, font)
    ea = ea > 0 and ea - (1000 * Frametime()) or 0
    surface_SetDrawColor(102, 255, 255, ea)

    for i = 1, math_random(5) do
        surface_DrawLine(x + math_random(charw), y + math_random(charh), x + math_random(charw), y + math_random(charh))
    end

    if (ne <= Curtime()) then
        ne = Curtime() + math_Rand(0.5 + (1 - intensity), 1.5 + (1 - intensity))
        ea = 255
    end
end

function DrawFireText(intensity, text, font, x, y, color, xalign, yalign, glow, shadow)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP

    local cw, ch = m_GetTextSize(text, font)
    for i = 1, cw do
        surface_SetDrawColor(255, math_random(255), 0, 150)
        surface_DrawLine(x - 1 + i, y + ch, x - 1 + i + math_random(-4, 4), y + math_random(ch * intensity, ch))
    end

    if (glow) then DrawGlowingText(true, text, font, x, y, color, xalign, yalign) end
    if (shadow) then draw_SimpleText(text, font, x + 1, y + 1, Color(0, 0, 0), xalign, yalign) end

    draw_SimpleText(text, font, x, y, color, xalign, yalign)
end

function DrawSnowingText(intensity, text, font, x, y, color, color2, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    color2 = color2 or Color(255, 255, 255)

    draw_SimpleText(text, font, x, y, color, xalign, yalign)
    surface_SetDrawColor(color2.r, color2.g, color2.b, 255)

    local tw, th = m_GetTextSize(text, font)
    for i = 1, intensity do
        local lx, ly = math_Rand(0, tw), math_Rand(0, th)

        surface_DrawLine(x + lx, y + ly, x + lx, y + ly + 1)
    end
end
