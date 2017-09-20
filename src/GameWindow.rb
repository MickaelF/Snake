require 'gosu'
require_relative 'Snake'
require_relative 'Grid'

class GameWindow < Gosu::Window
    def initialize(width = 1280, height = 720, fullscreen = false)
        super
        @gridSize = 10.0
        @grid = Grid.new(width / @gridSize, (height - 60.0) / @gridSize)
        @snake = Snake.new(@gridSize, @gridSize)
        @points = Rectangle.new()
        @compteur = 0

        @gameName = Gosu::Image.from_text("SNAKE", 30)
        @launchText = Gosu::Image.from_text("Appuyer sur ESPACE pour lancer le jeu", 20)
        @score = Gosu::Image.from_text("Score : 0", 15)

        @compteur = 0

        @lauchGame = false
        @point = Rectangle.new(100.0, 240.0, @gridSize, @gridSize, 0.0, Gosu::Color::YELLOW)


        @horizontalLimits = [Rectangle.new(0.0, 28.0, 1280.0, 2.0), Rectangle.new(0.0, 690.0, 1280.0, 2.0)]
    end

    def perdu
        @lauchGame = false
        @gameName = Gosu::Image.from_text("PERDU!", 30)
        @launchText = Gosu::Image.from_text("Appuyer sur ESPACE pour relancer le jeu", 20)
    end

    def nextPointPosition()
        updateGrid()
        return @grid.getNextPosition()
    end

    def collisionWithLevelLimits
        snakeHead = @snake.getSnakeHead
        if snakeHead[0] > 1280.0 || snakeHead[0] < 0.0 || snakeHead[1] < 30.0 || snakeHead[1] > 690.0
            perdu()
        end
    end

    def collisionWithPoint
        if @point.intersect(@snake.tailRectangleArray.first)
            @snake.addPart()
            nextPosition = nextPointPosition()
            @point.xPos = nextPosition[0] * @gridSize
            @point.yPos = (nextPosition[1] * @gridSize) + 30.0

            @score = Gosu::Image.from_text("Score : #{@snake.sizeTail - 10}", 15)
        end
    end

    def updateGrid
        @grid.allTrue()
        tail = @snake.tailRectangleArray
        tail.each() do |rect|
            rectCase = [rect.xPos / @gridSize, rect.yPos / @gridSize]
            rectSize = [rect.width / @gridSize, rect.height / @gridSize]
            1.upto(rectSize[0]) do |i|
                1.upto(rectSize[1]) do |j|
                    @grid.setToFalse(rectCase[0] + i*rect.moveX - 1, rectCase[1] + j*rect.moveY - 1)
                end
            end
        end
    end

    def update
        if @lauchGame
            if Gosu.button_down?(Gosu::KbDown)
                @snake.changeDirection(0.0, 1.0)
            elsif Gosu.button_down?(Gosu::KbUp)
                @snake.changeDirection(0.0, -1.0)
            elsif Gosu.button_down?(Gosu::KbLeft)
                @snake.changeDirection(-1.0, 0.0)
            elsif Gosu.button_down?(Gosu::KbRight)
                @snake.changeDirection(1.0, 0.0)
            end
            if @compteur % 4 == 0
                perdu() if !@snake.update()
            end
            collisionWithLevelLimits()
            collisionWithPoint()
            @compteur += 1
        else
            if Gosu.button_down?(Gosu::KbSpace)
                @lauchGame = true
                @snake.putToStart
                @score = Gosu::Image.from_text("Score : 0", 15)
            end
        end

    end

    def draw
        if !@lauchGame
            @gameName.draw(640.0, 360.0, 1.0)
            @launchText.draw(640.0, 410.0, 1.0)
        end
        @snake.draw()
        @point.draw()
        @horizontalLimits[0].draw()
        @horizontalLimits[1].draw()

        @score.draw(1100.0, 10.0, 1.0)
    end
end
