class Mastermind
    attr_reader :code, :hints

    @@colors = ["red", "orange", "yellow", "green", "blue", "violet"]
    
    def initialize
        @code = @@colors.sample(4)
        @hints = {}
    end
    def self.correct_input?(input)
        return false if input.size < 4
        (input - @@colors).empty?
    end

    def create_hints(input)
        @hints[:color_position] = count_color_and_position(input)
        @hints[:color] = count_colors(input)
        
        @hints
    end

    def print_hints
        arr = Array.new(0)
        if @hints[:color] > @hints[:color_position]
            @hints[:color_position].times { arr << 'BLACK'}
            (@hints[:color] - @hints[:color_position]).times { arr << 'WHITE'}
        else
            @hints[:color_position].times { arr << 'BLACK'}
        end

        print arr
    end
    def self.colors
        @@colors
    end

    private

    def count_color_and_position(input)
        color_position = 0
        input.each_with_index { |value, index| color_position += 1 if input[index] == @code[index] }
        color_position
    end

    def count_colors(input)
        code.size - (code - input).size
    end

end

def main
    length = 4
    turns = 0
    your_code = nil
    game = Mastermind.new

    puts "You need to guess the color and position of the elements of the code."
    puts "There are #{Mastermind.colors.size} colors: #{Mastermind.colors}"
    puts "The length of the code is #{length}."
    puts "The code is generate randomly"
    puts 'Please when ask, introduce the colors type them and separete them with commas. I.e: "red, green, yellow, blue"'
    puts 'HINTS: 1 per each correct; "BLACK" -> correct color and position; "WHITE" -> correct color'



    while turns <= 12 do
        puts "\nTurn: #{turns}"
        
        loop do
            puts "Introduce colors: "
            your_code = gets.chomp.downcase.split(', ')
            break if Mastermind.correct_input?(your_code)
            puts "Incorrect input, pls try again.\n"
        end
       
        game.create_hints(your_code)
    
        puts "\nYour code"
        print your_code
        puts
        puts "Hints"
        game.print_hints
        puts "\n"

        if game.hints[:color_position] == 4
            print game.code
            break
        end

        turns += 1
    end
    



end

main