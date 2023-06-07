local buttons = {}

function drawRect(x, y, width, height, radius, color, colorStroke, sizeStroke, data)
    colorStroke = tostring(colorStroke)
    sizeStroke = tostring(sizeStroke)

    if (not buttons[radius]) then
        local raw = string.format([[
            <svg width='%s' height='%s' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <mask id='path_inside' fill='#FFFFFF' >
                    <rect width='%s' height='%s' rx='%s' />
                </mask>
                <rect opacity='1' width='%s' height='%s' rx='%s' fill='#FFFFFF' stroke='%s' stroke-width='%s' mask='url(#path_inside)'/>
            </svg>
        ]], width, height, width, height, radius, width, height, radius, colorStroke, sizeStroke)
        buttons[radius] = svgCreate(width, height, raw)
    end
    if (buttons[radius]) then
        dxDrawImage(data.offset.x + (x * scale), data.offset.y + (y * scale), (width * scale), (height * scale), buttons[radius], 0,0,0, color)
    end
end

function reMap (x, in_min, in_max, out_min, out_max)
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
end

-- screen's resource's
screen = Vector2 (guiGetScreenSize ());
resolution = Vector2 (1920, 1080);

scale = reMap (screen.x, 1024, 1920, 0.75, 1);

-- dx's resource's
function DxImage (x, y, width, height, image, ...)
    return dxDrawImage (offset.x + (x * scale), offset.y + (y * scale), (width * scale), (height * scale), image, ...);
end

function DxText (text, x, y, width, height, ...)
    return dxDrawText (text, offset.x + (x * scale), offset.y + (y * scale), (offset.x + (x * scale)) + (width * scale), (offset.y + (y * scale)) + (height * scale), ...);
end

function DxRectangle (x, y, width, height, ...)
    return dxDrawRectangle (offset.x + (x * scale), offset.y + (y * scale), (width * scale), (height * scale), ...);
end

function isMouseInPosition (x, y, width, height, parent)
    if not isCursorShowing () then
        return false;
    end

    local cursor = {getCursorPosition ()};
    local cursorX, cursorY = (cursor[1] * screen.x), (cursor[2] * screen.y);

    local x, y = parent.offset.x + (x * scale), parent.offset.y + (y * scale);

    return ((cursorX >= x and cursorX <= (x + (width * scale))) and (cursorY >= y and cursorY <= (y + (height * scale))));
end