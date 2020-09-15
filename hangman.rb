class Hangman

    def initialize
        @word = ""
        @hint = ""
        @letters = ('a'..'z')
        @word_lines = ""
        @lives = 6
        @guessed_letters = ""
        @hangman_pics = [
            '''
            +---+
            |   |
                |
                |
                |
                |
          =========''', '''
            +---+
            |   |
            O   |
                |
                |
                |
          =========''', '''
            +---+
            |   |
            O   |
            |   |
                |
                |
          =========''', '''
            +---+
            |   |
            O   |
           /|   |
                |
                |
          =========''', '''
            +---+
            |   |
            O   |
           /|\  |
                |
                |
          =========''', '''
            +---+
            |   |
            O   |
           /|\  |
           /    |
                |
          =========''', '''
            +---+
            |   |
            O   |
           /|\  |
           / \  |
                |
          =========''']
    end

    #Chooses the word and hint combo from the .txt file
    def choose_word
        file = File.open("hangman_words.txt", "r")
        #Choose a random file line
        n = (file.readlines().size.to_i)
        i = rand(1..n)
        i-=1
        #Won't work if I don't close and reopen. Why??
        file.close                          
        file = File.open("hangman_words.txt", "r")
        selected_line = file.readlines[i]
        file.close
        new_array = selected_line.split(',')
        @word = new_array[0].to_s
        @hint = new_array[1].to_s.strip
        
        # update word lines to correct length
        @word.size.times do
            @word_lines += "_" end
    end

    def add_to_game
        puts "Congratulations! You won"
        puts "As the winner, you now have the right to add to the game!"
        puts "Would you like to add your own word and hint to be saved for next time? y/n"
        user_answer = gets.chomp
        valid_answer = ['y','n']
        if valid_answer.include?(user_answer)
            if user_answer == 'n'
                puts "Okay, see you next time!"
            else
                puts "Okay, what is your secret word?"
                secret_word = gets.chomp
                puts "Your secret word is #{ secret_word }"
                puts "What is the hint for your secret word?"
                secret_word_hint = gets.chomp
                puts "Okay, your secret word is #{ secret_word } and your hint is #{ secret_word_hint }"
                puts "Thankyou for contributing to the hangman game! See you next time"
                file = File.open('hangman_words.txt', 'a')
                file.write("\n#{secret_word}, #{ secret_word_hint }")
                file.close
            end
        else
            puts "What was that?
            "
            add_to_game
        end
    end

    def make_guess
        puts "You have #{ @lives } live(s) remaining. Make a guess"
        puts "Guessed letters: #{ @guessed_letters.split('').join(' ') }"
        guess = gets.chomp
        puts ""
       
        if guess.downcase == "exit"
            puts "Thanks for playing!"
        
        else
            puts "You guessed #{ guess }"
            guess.downcase!
            if @letters.include? guess #If valid guess

                if @guessed_letters.include? guess #Unique guess?
                    puts "Silly, you've already guessed that one!"
                    make_guess
                else
                    @guessed_letters << guess
                    if @word.include? guess #If valid correct guess

                        new_lines = @word_lines.split('') #Update word-line display
                        new_lines.each_with_index do |letter, index|
                            #replace blank value with guessed letter if correct
                            if letter == "_" && @word.split('')[index] == guess
                                new_lines[index] = guess
                            end
                        end
                        @word_lines = new_lines.join('')
                        puts ""
                        puts "Correct guess!"
                        puts "#{ @word_lines.split('').join(' ') }"

                        if @word_lines == @word #Game over?
                            add_to_game
                        else
                            make_guess
                        end
                    else #If valid incorrect guess
                        @lives -= 1

                        case @lives
                        when 5
                            puts "#{ @hangman_pics[1] }"
                            puts "Nope"
                            puts "#{ @word_lines.split('').join(' ') }"
                            make_guess
                        when 4
                            puts "#{ @hangman_pics[2] }"
                            puts "Sorry.. please try again"
                            puts "#{ @word_lines.split('').join(' ') }"
                            make_guess
                        when 3
                            puts "#{ @hangman_pics[3] }"
                            puts "That's not it.."
                            puts "#{ @word_lines.split('').join(' ') }"
                            make_guess
                        when 2
                            puts "#{ @hangman_pics[4] }"
                            puts "Things are not looking good.."
                            puts "#{ @word_lines.split('').join(' ') }"
                            make_guess
                        when 1
                            puts "#{ @hangman_pics[5] }"
                            puts "Last chance!"
                            puts "#{ @word_lines.split('').join(' ') }"
                            make_guess
                        else
                            puts "#{ @hangman_pics[6] }"
                            puts "#{ @word_lines.split('').join(' ') }"
                            puts "Sorry... you lose. The word was #{ @word }"
                        end
                    end
                end
            else #If not a valid guess
                puts "#{ guess } was an invalid guess, please enter guess again"
                make_guess
            end
        end
    end

    def begin
        choose_word
        puts "#{ @hangman_pics[0] }"
        puts "New game started.. "
        puts "Your clue is '#{ @hint }'"      
        puts "#{ @word_lines.split('').join(' ') }"
        puts ""
        make_guess
    end

end

Hangman.new.begin
