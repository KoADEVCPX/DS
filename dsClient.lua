local screen = Vector2{guiGetScreenSize()}
x,y = screen.x/1920, screen.y/1080
dx = {
    panels = {},
    rectangles = {},
    images = {},
    texts = {},
    animations = {},
    editboxs = {}
}

local main = {}

function Class(tbl)
    setmetatable(tbl, {
        __call = function(cls, ...)
            local self = {}

            setmetatable(self, {
                __index = cls
            })
            self:constructor(...)
            return self
        end
    })
    
    return tbl
end

----------------------------------------------------- Functions

local Lib = Class({
    constructor = function(self, width, height)
        table.insert(dx.panels, {
            visible = false,
        })
        self.index = #dx.panels
        self.offset = Vector2 ((screen.x - (width * scale)) / 2, (screen.y - (height * scale)) / 2);
    end;

    setVisible = function(self, visible)
        dx.panels[self.index].visible = visible
    end;

    isVisible = function(self)
        return dx.panels[self.index].visible
    end;

    close = function(self, key)
        if ( key ) then
            
        end
    end;
})

local Rectangle = Class({
    constructor = function(self, x,y,w,h, data)
        table.insert(main, {
            position = {x=x, y=y, w=w, h=h},
            type = 'rectangle',
            data = data
        })
        self.index = #main
    end;

    setColor = function(self, color)
        main[self.index].color = color
        return true
    end;

    setAlpha = function(self, alpha)
        main[self.index].color[4] = alpha
    end;

    alphaTo = function(self, alpha, time, type)
        self.tick = getTickCount()
        main[self.index].animation = {
            tick = self.tick,
            time = time,
            type = type,
            goto = alpha
        }
    end;

    onClick = function(self, func)
        main[self.index].onClick = func
    end;

    setVisible = function(self, visible)
        main[self.index].data.visible = visible
    end;

    hover = function(self, data)
        main[self.index].hover = data
    end;

    posX = function(self, value)
        main[self.index].data.posX = ( scale * value )
    end;

    posY = function(self, value)
        main[self.index].data.posY = ( scale * value )
    end;
})

local Image = Class({
    constructor = function(self, x,y,w,h, data)
        table.insert(main, {
            position = {x=x, y=y, w=w, h=h},
            type = 'image',
            data = data
        })
        self.index = #main
    end;

    setColor = function(self, color)
        main[self.index].color = color
        return true
    end;

    alphaTo = function(self, alpha, time, type)
        self.tick = getTickCount()
        main[self.index].animation = {
            tick = self.tick,
            time = time,
            type = type,
            goto = alpha
        }
    end;
    
    onClick = function(self, func)
        main[self.index].onClick = func
    end;

    setVisible = function(self, visible)
        main[self.index].data.visible = visible
    end;

    hover = function(self, data)
        main[self.index].hover = data
    end;

    posX = function(self, value)
        main[self.index].data.posX = ( scale * value )
    end;

    posY = function(self, value)
        main[self.index].data.posY = ( scale * value )
    end;
})

local Text = Class({
    constructor = function(self, x,y,w,h, data)
        table.insert(main, {
            position = {x=x, y=y, w=w, h=h},
            type = 'text',
            data = data
        })
        self.index = #main
    end;

    setColor = function(self, color)
        main[self.index].color = color
        return true
    end;

    alphaTo = function(self, alpha, time, type)
        self.tick = getTickCount()
        main[self.index].animation = {
            tick = self.tick,
            time = time,
            type = type,
            goto = alpha
        }
    end;

    setText = function(self, text)
        main[self.index].data.text = text
    end;

    setVisible = function(self, visible)
        main[self.index].data.visible = visible
    end;

    posX = function(self, value)
        main[self.index].data.posX = ( scale * value )
    end;

    posY = function(self, value)
        main[self.index].data.posY = ( scale * value )
    end;
})

local EditBox = Class({
    constructor = function(self, x,y,w,h, data)
        table.insert(dx.editboxs, {
            position = {x=x, y=y, w=w, h=h},
            data = data,
        })
        self.index = #dx.editboxs
    end;

    setColor = function(self, color)
        dx.editboxs[self.index].color = color
        return true
    end;

    alphaTo = function(self, alpha, time, type)
        self.tick = getTickCount()
        dx.editboxs[self.index].animation = {
            tick = self.tick,
            time = time,
            type = type,
            goto = alpha
        }
    end;

    getText = function(self)
        return dx.editboxs[self.index].data.text.text
    end;

    setText = function(self, text)
        dx.editboxs[self.index].data.text.text = text
    end
})

----------------------------------------------------- Functions

addEventHandler('onClientRender', root, function()

    if #dx.panels > 0 then

        --------------------- RECTANGLES

        hover_alpha = (hover_data and hover_alpha < hover_data.target - 1) and math.abs( math.sin( ( getTickCount()-hover_data.tick ) / 200) * hover_data.target ) or (hover_data and hover_data.target or 0)

        if ( hover_data ) and ( hover_alpha >= ( hover_data.target ) - 1 ) then
            hover_alpha = hover_data.target
            hover_data = false
        end

        for i,v in ipairs(main) do
            if v.data.parent:isVisible() and (v.data.visible) then
                if (v.animation) then
                    main[i].alpha = interpolateBetween((main[i].alpha or 0), 0,0, v.animation.goto,0,0, (getTickCount()-v.animation.tick)/(v.animation.time), v.animation.type)
                    if (getTickCount()-v.animation.tick)/(v.animation.time) >= 1 then
                        main[i].alpha = v.animation.goto
                        main[i].animation = false
                    end
                end
                if ( v.type == 'rectangle' ) then
                    drawRect(v.position.x + ( v.data.posX or 0 ), v.position.y + ( v.data.posY or 0 ), v.position.w, v.position.h, v.data.radius, tocolor(v.data.color[1], v.data.color[2], v.data.color[3], (main[i].alpha or v.data.color[4])), '#FFFFFF', (v.data.size or 5), v.data.parent)
                    if isMouseInPosition( v.position.x + ( v.data.posX or 0 ), v.position.y + ( v.data.posY or 0 ), v.position.w, v.position.h, v.data.parent ) and type( v.hover ) == 'table' then
                        if ( not hover_data ) then
                            hover_data = {tick=getTickCount(), target=v.hover[4], index=i}
                        end
                        drawRect(v.position.x + ( v.data.posX or 0 ), v.position.y + ( v.data.posY or 0 ), v.position.w, v.position.h, v.data.radius, tocolor(v.hover[1], v.hover[2], v.hover[3], hover_alpha), '#FFFFFF', (v.data.size or 5), v.data.parent)
                    end
                elseif ( v.type == 'image' ) then
                    --dxDrawImage(x*v.position.x, y*v.position.y, x*v.position.w, y*v.position.h, v.data.texture, v.data.rot[1],v.data.rot[2], v.data.rot[3], tocolor(v.data.color[1], v.data.color[2], v.data.color[3], (main[i].alpha or v.data.color[4])))
                    dxDrawImage (v.data.parent.offset.x + ((v.position.x + ( v.data.posX or 0 )) * scale), v.data.parent.offset.y + ((v.position.y + ( v.data.posY or 0 )) * scale), (v.position.w * scale), (v.position.h * scale), v.data.texture, v.data.rot[1],v.data.rot[2], v.data.rot[3], tocolor(v.data.color[1], v.data.color[2], v.data.color[3], (main[i].alpha or v.data.color[4])))
                    if isMouseInPosition( v.data.parent.offset.x + ((v.position.x + ( v.data.posX or 0 )) * scale), v.data.parent.offset.y + ((v.position.y + ( v.data.posY or 0 )) * scale), (v.position.w * scale), (v.position.h * scale) ) and type( v.hover ) == 'table' then
                        if ( not hover_data ) then
                            hover_data = {tick=getTickCount(), target=v.hover[4], index=i}
                        end
                        dxDrawImage (v.data.parent.offset.x + ((v.position.x + ( v.data.posX or 0 )) * scale), v.data.parent.offset.y + ((v.position.y + ( v.data.posY or 0 )) * scale), (v.position.w * scale), (v.position.h * scale), v.data.texture, v.data.rot[1],v.data.rot[2], v.data.rot[3], tocolor(v.hover[1], v.hover[2], v.hover[3], hover_alpha))
                    end
                elseif ( v.type == 'text' ) then
                    dxDrawText (v.data.text, v.data.parent.offset.x + ((v.position.x + ( v.data.posX or 0 )) * scale), v.data.parent.offset.y + ((v.position.y + ( v.data.posY or 0 )) * scale), (v.data.parent.offset.x + ((v.position.x + ( v.data.posX or 0 )) * scale)) + (v.position.w * scale), (v.data.parent.offset.y + ((v.position.y + ( v.data.posY or 0 )) * scale)) + (v.position.h * scale), tocolor( v.data.color[1], v.data.color[2], v.data.color[3], (main[i].alpha or v.data.color[4])), v.data.scale, v.data.font, v.data.alignX, v.data.alignY)
                end
            end
        end

        --[[for i,v in ipairs(dx.rectangles) do
            if v.data.parent:isVisible() and (v.data.visible) then
                if (v.animation) then
                    dx.rectangles[i].alpha = interpolateBetween((dx.rectangles[i].alpha or 0), 0,0, v.animation.goto,0,0, (getTickCount()-v.animation.tick)/(v.animation.time), v.animation.type)
                    if (getTickCount()-v.animation.tick)/(v.animation.time) >= 1 then
                        dx.rectangles[i].alpha = v.animation.goto
                        dx.rectangles[i].animation = false
                    end
                end
                drawRect(x*v.position.x, y*v.position.y, x*v.position.w, y*v.position.h, v.data.radius, tocolor(v.data.color[1], v.data.color[2], v.data.color[3], (dx.rectangles[i].alpha or v.data.color[4])), '#FFFFFF', (v.data.size or 5))
                if isMouseInPosition( x*v.position.x, y*v.position.y, x*v.position.w, y*v.position.h ) and type( v.hover ) == 'table' then
                    if ( not hover_data ) then
                        hover_data = {tick=getTickCount(), target=v.hover[4]}
                    end
                    drawRect(x*v.position.x, y*v.position.y, x*v.position.w, y*v.position.h, v.data.radius, tocolor(v.hover[1], v.hover[2], v.hover[3], hover_alpha), '#FFFFFF', (v.data.size or 5))
                end
            end
        end

        ----------------- IMAGES

        for i,v in ipairs(dx.images) do
            if v.data.parent:isVisible() and (v.data.visible) then
                if (v.animation) then
                    dx.images[i].alpha = interpolateBetween((dx.images[i].alpha or 0), 0,0, v.animation.goto,0,0, (getTickCount()-v.animation.tick)/(v.animation.time), v.animation.type)
                    if (getTickCount()-v.animation.tick)/(v.animation.time) >= 1 then
                        dx.images[i].alpha = v.animation.goto
                        dx.images[i].animation = false
                    end
                end
                dxDrawImage(x*v.position.x, y*v.position.y, x*v.position.w, y*v.position.h, v.data.texture, v.data.rot[1],v.data.rot[2], v.data.rot[3], tocolor(v.data.color[1], v.data.color[2], v.data.color[3], (dx.images[i].alpha or v.data.color[4])))

                if isMouseInPosition( x*v.position.x, y*v.position.y, x*v.position.w, y*v.position.h ) and type( v.hover ) == 'table' then
                    if ( not hover_data ) then
                        hover_data = {tick=getTickCount(), target=v.hover[4]}
                    end
                    dxDrawImage(x*v.position.x, y*v.position.y, x*v.position.w, y*v.position.h, v.data.texture, v.data.rot[1],v.data.rot[2], v.data.rot[3], tocolor(v.hover[1], v.hover[2], v.hover[3], hover_alpha))
                end

            end
        end

        ----------------- TEXTS

        for i,v in ipairs(dx.texts) do
        if v.data.parent:isVisible() and (v.data.visible)  then
                if (v.animation) then
                    dx.texts[i].alpha = interpolateBetween((dx.texts[i].alpha or 0), 0,0, v.animation.goto,0,0, (getTickCount()-v.animation.tick)/(v.animation.time), v.animation.type)
                    if (getTickCount()-v.animation.tick)/(v.animation.time) >= 1 then
                        dx.texts[i].alpha = v.animation.goto
                        dx.texts[i].animation = false
                    end
                end
                dxDrawText(v.data.text, x*( v.position.x ), y*( v.position.y ), x*( v.position.x + v.position.w ), y*( v.position.y + v.position.h ), tocolor( v.data.color[1], v.data.color[2], v.data.color[3], (dx.texts[i].alpha or v.data.color[4])), v.data.scale, v.data.font, v.data.alignX, v.data.alignY)
            end
        end
]]
    end
end)

addEventHandler('onClientClick', root, function(button,state)
    if button == 'left' and state == 'down' then
        if type( hover_data ) == 'table' and ( main[hover_data.index] ) and main[hover_data.index].data.parent:isVisible( ) then
            if type( main[hover_data.index].onClick ) == 'function' then
                main[hover_data.index].onClick()
            end
        end
    end
end)


local painel = Lib(200, 200)

local rectangle = Rectangle(0,0, 200, 200, {
    parent = painel,
    color = {255,0,0, 255},
    radius = 20,
    visible = true,
    size = 1,
})

local text = Text(0,0, 200, 200, {
    parent = painel,
    text = 'Teste',
    scale = 1,
    font = 'default-bold',
    alignX = 'center',
    alignY = 'center',
    color = {255,255,255, 255},
    visible = true
})

rectangle:hover({255,255,255, 40})
rectangle:alphaTo(255, 2000, 'OutQuad')

--[[local editbox = EditBox(0, 0, 200, 50, {
    parent = painel,
    background = {
        color = {255,0,0,255},
        radius = 5,
        size = 1,
    },
    text = {
        default = 'Insira o RG.',
        text = '',
        scale = 1,
        font = 'default-bold',
        alignX = 'center',
        alignY = 'center',
        type = 'number',
        max_characters = 20,
        color = {255,255,255, 255}
    }
})]

editbox:alphaTo(255, 2000, 'OutQuad')

local texto = editbox:getText()

setTimer(function()
    print(editbox:getText())
    print(editbox:setText('Olá mundo!'))
end,2000,1)]]

painel:setVisible(true)