require 'gosu'

class Rectangle
    attr_accessor :xPos, :yPos, :width, :height, :color, :moveX, :moveY, :scale
    def initialize(x = 0.0, y = 0.0, width = 5.0, height = 2.0, speedWidth = 5.0, speedHeight = 2.0, color = Gosu::Color::WHITE)
        @xPos = x
        @yPos = y
        @width = width
        @height = height
        @color = color
        @moveX = 0.0
        @moveY = 0.0
        @speedMoveX = speedWidth
        @speedMoveY = speedHeight
        @scale = true
    end

    def move
            @xPos += @moveX * @speedMoveX
            @yPos += @moveY * @speedMoveY
    end

    def intersect(otherRectangle)
        if @xPos < otherRectangle.xPos + otherRectangle.width && @xPos + @width > otherRectangle.xPos && @yPos < otherRectangle.yPos + otherRectangle.height && @yPos + @height > otherRectangle.yPos
            return true
        end
        return false
    end

    def scaleUp(maxSize)
        if @moveX != 0
            @width += @speedMoveX
            if @moveX == -1
                @xPos -= @speedMoveX
            end
        else
            @height += @speedMoveY
            if @moveY == -1
                @yPos -= @speedMoveY
            end
        end
    end

    def scaleDown
        if @scale
            if @moveX != 0
                @width -= @speedMoveX
                if @moveX == 1
                    @xPos += @speedMoveX
                end
            else
                @height -= @speedMoveY
                if @moveY == 1
                    @yPos += @speedMoveY
                end
            end
        else
            @scale = true
        end
    end

    def draw
        #Debug drawing
        #Gosu.draw_rect(@xPos-1, @yPos-1, @width+2, @height+2, color = Gosu::Color::RED, 0)
        #Gosu.draw_rect(@xPos+1, @yPos+1, @width-2, @height-2, @color, 1)

        Gosu.draw_rect(@xPos, @yPos, @width, @height, @color, 1)
    end
end
