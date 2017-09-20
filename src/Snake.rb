require 'gosu'
require_relative  'Rectangle'

class Snake
    attr_reader :tailRectangleArray, :sizeTail
    def initialize(widthSnakePart = 5.0, heightSnakePart = 2.0)

        @snakeSegWidth = widthSnakePart
        @snakeSegHeight = heightSnakePart
        @tailRectangleArray = Array.new()

        putToStart()

    end

    def putToStart
        @sizeTail = 10
        @tailRectangleArray.clear
        @tailRectangleArray.push(Rectangle.new(10.0, 40.0, @snakeSegWidth * @sizeTail, @snakeSegHeight, @snakeSegWidth, @snakeSegHeight))
        @tailRectangleArray.first.moveX = 1.0
    end


    def getSnakeHead
        xPos = @tailRectangleArray.first.xPos
        yPos = @tailRectangleArray.first.yPos
        if @tailRectangleArray.first.moveX == 1.0
            xPos += @tailRectangleArray.first.width
        elsif @tailRectangleArray.first.moveY == 1.0
            yPos += @tailRectangleArray.first.height
        end
        return [xPos, yPos]
    end

    def changeDirection(x, y)
        snakeHead = @tailRectangleArray.first
        if x != 0 && snakeHead.moveX == 0
            newDirection = Rectangle.new(0, 0, 0, @snakeSegWidth, @snakeSegWidth, @snakeSegHeight)
            newDirection.xPos = snakeHead.xPos + snakeHead.width if x == 1
            newDirection.xPos = snakeHead.xPos if x == -1
            newDirection.yPos = snakeHead.yPos if snakeHead.moveY == -1
            newDirection.yPos = snakeHead.yPos + snakeHead.height - @snakeSegHeight  if snakeHead.moveY == 1
            newDirection.moveX = x
            newDirection.moveY = y
            @tailRectangleArray.unshift(newDirection)
        elsif y != 0 && snakeHead.moveY == 0
            newDirection = Rectangle.new(0, 0, @snakeSegHeight, 0, @snakeSegHeight, @snakeSegWidth)
            newDirection.xPos = snakeHead.xPos + snakeHead.width - @snakeSegWidth if snakeHead.moveX == 1
            newDirection.xPos = snakeHead.xPos if snakeHead.moveX == -1
            newDirection.yPos = snakeHead.yPos if y == -1
            newDirection.yPos = snakeHead.yPos + @snakeSegHeight if y == 1
            newDirection.moveX = x
            newDirection.moveY = y
            @tailRectangleArray.unshift(newDirection)
        end
    end

    def addPart
        nbPartAdd = 1
        @sizeTail += nbPartAdd
        if @tailRectangleArray.length == 1
            @tailRectangleArray[0].xPos -= @snakeSegWidth * nbPartAdd if @tailRectangleArray[0].moveX == 1
            @tailRectangleArray[0].width += @snakeSegWidth * nbPartAdd if @tailRectangleArray[0].moveX == -1
            @tailRectangleArray[0].yPos -= @snakeSegHeight * nbPartAdd if @tailRectangleArray[0].moveY == 1
            @tailRectangleArray[0].height += @snakeSegHeight * nbPartAdd if @tailRectangleArray[0].moveY == -1
        else
            @tailRectangleArray.last.scale = false
        end
    end

    def collisionWithOwn
        head = @tailRectangleArray.first
        1.upto(@tailRectangleArray.length - 1) do |i|
            rect = @tailRectangleArray[i]
            return true if head.intersect(rect)
        end
        return false
    end

    def update
        if @tailRectangleArray.length > 1
            val = @sizeTail * @snakeSegWidth
            @tailRectangleArray.first.scaleUp(val)
            @tailRectangleArray.last.scaleDown()
            @tailRectangleArray.pop() if @tailRectangleArray.last.width <= 0.0 || @tailRectangleArray.last.height <= 0.0
        else
            @tailRectangleArray.first.move()
        end
        return !collisionWithOwn
    end

    def draw
        @tailRectangleArray.each() do |part|
            part.draw()
        end
    end
end
