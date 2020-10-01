
class Mastermind
    attr_reader :code, :hints

    @@colors = ["red", "orange", "yellow", "green", "blue", "violet", "pink", 'cyan', 'brown', 'grey']
    
    def initialize(human_player = true, length = 4, attemps = 12)
        @human_player = human_player
        @length = length
        @code = create_code
        @pc = @@colors.repeated_permutation(length).to_a unless human_player
        @hints = {}
        @attemps = attemps
    end
    
    def play
        turn  = 1
        while turn <= @attemps do
            
            puts "\nTurn: #{turn}"
            input  = @human_player ? self.human_input : self.pc_input(turn)
            self.create_hints(input)
            self.delete_extras unless @human_player
            self.display_feedback(input)
            sleep(1) unless @human_player
    
            if self.hints[:color_position] == @length
                puts "\nCode:"
                print self.code
                puts
                break
            end
    
            turn += 1
        end
    end
    def self.rules
        puts '*' * 55 + "RULES" + '*' * 55
        puts "You need to guess the color and position of the elements of the code."
        puts "There are #{Mastermind.colors.size} colors: #{Mastermind.colors}"
        puts "The length of the code is #{@length}."
        puts "The code is generate randomly"
        puts 'Please when ask, introduce the colors type them and separete them with commas. I.e: "red, green, yellow, blue"'
        puts 'HINTS: 1 per each correct; "BLACK" -> correct color and position; "WHITE" -> correct color'
        puts '*' * 115
        puts '*' * 115
    end

    private

    def self.colors
        @@colors
    end

    def correct_input?(input)
        return false if input.size < @length
        (input - @@colors).empty?
    end

    def pc_input(turn)
        return @pc[7] if turn == 1

        @pc.first
    end

    def human_input
        your_code = nil
        loop do
            puts "Introduce code: "
            your_code = gets.chomp.downcase.split(', ')
            break if correct_input?(your_code)
            puts "Incorrect input, pls try again.\n"
        end
        your_code
    end

    def delete_extras
        @pc.delete_if {|arr| count_color_and_position(arr) == @hints[:color_position]}
    end

    def display_feedback(input_code)
        puts '_' * 53 + 'Feedback' + '_' * 53
        puts "\nCodebreaker code:"
        print input_code
        puts
        puts "Hints"
        self.print_hints
        puts "\n"
        puts '_' * 115

    end

    def create_code
        return @@colors.sample(@length) if @human_player
        code  = []
        
        loop do
            @length.times do
                puts "Introduce color: "
                color = gets.chomp
                code << color
            end
            break if correct_input?(code)
            puts 'Incorrect colors, please try again.'
        end
        code
    end

    def count_color_and_position(input)
        color_position = 0
        input.each_with_index { |value, index| color_position += 1 if input[index] == @code[index] }
        color_position
    end

    def count_colors(input)
        code.size - (code - input).size
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

end

def main
    mode = nil
    length = nil
    attemps = nil
    Mastermind.rules
    puts "\nUse the index to  select a option.\n"
    
    puts '*' * 115
    puts 'Select the length of the code:'
    puts '1. Code length: 4'
    puts '2. Code length: 6'
    puts '3. Code length: 8'
    
    loop do
        puts 'Introduce length: '
        length = gets.chomp
        break if length.match?(/[1-3]/)
        puts 'Incorrect number. Please try again'
    end

    length = case length
        when '1' then 4
        when '2' then 6
        when '3' then 8
        end

    puts '*' * 115
    puts 'Select the number of attempts:'
    puts '1. attemps: 10'
    puts '2. attemps: 12'
    
    loop do
        puts 'Introduce attemps:'
        attemps = gets.chomp
        break if attemps.match?(/[1-2]/)
        puts 'Incorrect number. Please try again'
    end

    attemps = case attemps
        when '1' then 10
        when '2' then 12
    end
    puts '*' * 115
    puts 'Select game mode:'
    puts '1. Player vs Pc. You are the codebreaker.'
    puts '2. Pc vs Player. You are the codemaker.'
    
    loop do
    puts 'Introduce mode:'
    mode = gets.chomp
    puts
    break if mode == '1' || mode == '2'
    puts 'Incorrect number, please try again'
    end
    puts '*' * 115

    game = mode == '1' ? Mastermind.new(true, length, attemps) : Mastermind.new(false, length, attemps)
    game.play

end

main