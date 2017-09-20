class Grid
    def initialize(width, height)
        @width = width
        @height = height
        @grid = Array.new(width, Array.new(height, true))
    end

    def allTrue
        @grid = Array.new(@width, Array.new(@height, true))
    end

    def setToFalse(i, j)
        @grid[i][j] = false
    end

    def getNextPosition
        begin
            x = rand(@width)
            y = rand(@height)
            return [x, y] if @grid[x][y]
        end while @grid[x][y] != true
    end

end
