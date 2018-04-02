--Title: Math Quiz
--Name: Sasha Malko
--Course: ICS2O/3C
--This program displays a math question and asks the user to answer in a numeric textfield
--terminal.

---------------------------------------------------------------------------------------------

--hide the status bar
display.setStatusBar(display.HiddenStatusBar)

--sets the backgorund colour
display.setDefault("background", 251/255, 166/255, 250/255)

---------------------------------------------------------------------------------------------
--LOCAL VARIABLES
---------------------------------------------------------------------------------------------

--create local variables
local questionObject
local correctObject
local incorrectObject
local numericField
local randomNumber1
local randomNumber2
local randomNumber3
local randomNumber4
local userAnswer
local correctAnswer
local incorrectAnswer
local randomOperator
local points = 0
local pointsObject
local totalSeconds = 10
local secondsLeft = 10
local clockText
local countDownTimer
local lives = 4
local heart1
local heart2
local heart3
local gameOver
local divide
local winner
local correctText
local squareRoot
local gameOverSound = audio.loadSound("Sounds/GameOver.mp3")
local gameOverSoundChannel
local winnerSound = audio.loadSound("Sounds/winner.mp3")
local winnerSoundChannel
local correctSound = audio.loadSound("Sounds/Correct.mp3")
local correctSoundChannel
local incorrectSound = audio.loadSound("Sounds/Incorrect.mp3")
local incorrectSoundChannel
local timesMultiplied
----------------------------------------------------------------------------------------------
--LOCAL FUNCTIONS
----------------------------------------------------------------------------------------------

local function AskQuestion()
	
	--generate random numbers between a max. and a min. number and a random operator
	randomNumber1 = math.random(1,20)
	randomNumber2 = math.random(1,20)
	randomNumber3 = math.random(1,10)
	randomNumber4 = math.random(1,10)
	randomNumber5 = math.random(1,5)
	randomNumber6 = math.random(1,5)
    randomOperator = math.random(1,7) 
    randomOperator = 7

    --display the points on the screen 
    pointsObject.text = "Points" .. " = ".. points
   
    --if the random operator is 1:
    if (randomOperator == 1) then
    	
    	--add the numbers
    	correctAnswer = randomNumber1 + randomNumber2
	
		--create question in text object
		questionObject.text = randomNumber1 .. "+" .. randomNumber2 .. "="

    --if the random operator is 2:
    elseif (randomOperator == 2) then 
    	
    	--subtract the numbers
	    correctAnswer = randomNumber1 - randomNumber2
	
	   --create a question in text object
       questionObject.text = randomNumber1 .. "-" .. randomNumber2 .. "="
     
         --if the correct answer is less than 0:
      	if (correctAnswer < 0) then 
      		
      		--allow the question to have a positive answer
        	correctAnswer = randomNumber2 - randomNumber1
      
         	--create a question in text object
         	questionObject.text = randomNumber2 .. "-" .. randomNumber1 .. "="
    	end 

    --if the random operator is 3:
    elseif (randomOperator == 3) then 
    	
    	--multiply the numbers
		correctAnswer = randomNumber3 * randomNumber4

		--create question in text object
		questionObject.text = randomNumber3 .. "*" .. randomNumber4 .. "="

    --if the random operator is 4:
    elseif (randomOperator == 4) then
    	--divide the numbers evenly
        divide = randomNumber3 * randomNumber4
        correctAnswer = divide / randomNumber3 
    	
	    --create question in text object
		questionObject.text = divide .. "/" .. randomNumber3 .. "="

    --if the random operator is 5:
	elseif (randomOperator == 5) then
		--square root the numbers without decimal answers 
    	squareRoot = randomNumber1 * randomNumber1
        correctAnswer = math.sqrt(squareRoot)
	
		--create question in text object
		questionObject.text = squareRoot .. " sqrt" 

    --if the random operator is 6:
	elseif (randomOperator == 6) then
		--have exponent questions
    	correctAnswer = randomNumber5^randomNumber6
	
		--create question in text object
		questionObject.text = randomNumber5 .. "^" .. randomNumber6 .. "="

    --if the random operator is 7:
    elseif (randomOperator == 7) then
    	--have factorial questions
    	function factorial(n)
         if (n == 0) then
           return 1
           else
            return n * factorial(n - 1)
    end end
end

for n = 0, 16 do
    io.write(n, "! = ", factorial(n), "\n")
end
   


local function HideCorrect()
	
	--allow the correct object to be invisible
	correctObject.isVisible = false
	
	--call the function to ask the question
	AskQuestion()
end

local function HideIncorrect()
	
	--allow the incorrect object to be invisible
	incorrectObject.isVisible = false

	--call the function to ask the question
	AskQuestion()
end

local function HideCorrectText()
	
	--alow the correct text to be invisible
	correctText.isVisible = false

	--call the function to ask the question
	AskQuestion()
end

local function NumericFieldListener(event)

	--user begins editing "numericField"
	if (event.phase == "began") then

		--clear text field
		event.target.text = ""
    
    --if the event phase is submitted:
	elseif event.phase == "submitted" then

		--when the answer is sumbitted (enter key is pressed) set user input to user's answer
		userAnswer = tonumber(event.target.text)

		--if the user's answer and the correct answer are the same:
		if (userAnswer == correctAnswer) then

			--reset the time
			secondsLeft = totalSeconds

			--make the correct object visible for a certain amount of time
			correctObject.isVisible = true
			timer.performWithDelay(1000,HideCorrect)

			--make the incorrect object invisible
			incorrectObject.isVisible = false
            
            --add one point and display it
			points = points + 1
			pointsObject.text = "Points" .. " = ".. points

			--play a correct sound effect
			correctSoundChannel = audio.play(correctSound)

			   --if the user gets to 5 points, allow them to win the game
			   if (points == 5) then 

			     --allow the winner image to be visible
	             winner.isVisible = true

	             --play the winner sound effect
	             winnerSoundChannel = audio.play(winnerSound)

	             --make the numeric text field invisible
	             numericField.isVisible = false

	             --make the total seconds 0
	             totalSeconds = 0
                end
			
		--if the user's answer and the correct answer are not the same:
        elseif (userAnswer) then

            --reset the time
            secondsLeft = totalSeconds

            --make the correct object invisible
			correctObject.isVisible = false

			--make the incorrect object visible for a certain amount of time
			incorrectObject.isVisible = true
			timer.performWithDelay(1000,HideIncorrect)

			--take away one life
			lives = lives - 1

			--display the correct answer for a certain amount of time
			correctText.text = "Correct Answer: " .. correctAnswer
			correctText.isVisible = true
			timer.performWithDelay(1000,HideCorrectText)

			--play an incorrect sound effect
			incorrectSoundChannel = audio.play(incorrectSound)
			    
			    --allow hearts to disapear if answer is incorrect
                if (lives == 3) then
	    	       heart3.isVisible = false
                elseif (lives == 2) then
	    	       heart2.isVisible = false
                --if there are no more lives:
                elseif (lives == 1) then 
                	heart1.isVisible = false
                   
                   --hide the correct text
	    		   timer.performWithDelay(0,HideCorrectText)
	    		   
	    		   --make the game over image visible
	    	       gameOver.isVisible = true
	    	       
	    	       --hide the numeric text field	
	    		   numericField.isVisible = false
	    		   
	    		   --make the clock text invisible
	    		   clockText.isVisible = false
	    		   
	    		   --play a game over sound effect
	    		   gameOverSoundChannel = audio.play(gameOverSound)

	        end
		end
    --clear text field
    event.target.text = ""
	end
end

local function UpdateTime()

	--decrement the number of seconds
	secondsLeft = secondsLeft - 1

	--display the number of seconds left in the clock object
	clockText.text = secondsLeft .. "" 
    
    --if the time is up:
	if (secondsLeft == 0) then
		
		--reset the number of seconds left
		secondsLeft = totalSeconds
		
		--take away one life
	    lives = lives - 1
	    
	    --call the function to ask the question
	    AskQuestion()
        
        --allow lives to disapear if the time runs out 
	    if (lives == 4) then
	    	heart4.isVisible = false
        elseif (lives == 3) then
	    	heart3.isVisible = false
	    elseif (lives == 2) then 
	    	heart2.isVisible = false
	    --if there are no lives left:
	    elseif (lives == 1) then
	    	heart1.isVisible = false
	    	
	    	--display a game over image
	    	gameOver.isVisible = true
	    	
	    	--hide numeric text field
	    	numericField.isVisible = false
	    	
	    	--hide clock text
	    	clockText.isVisible = false
	    	
	    	--play game over sound effect
	    	gameOverSoundChannel = audio.play(gameOverSound)			
	    end
    end
end




--function that calls the timer
local function StartTimer()
	
	--create a countdown timer that loops infinitely
	countDownTimer = timer.performWithDelay(1000, UpdateTime, 0)
end

----------------------------------------------------------------------------------------------
--OBJECT CREATION
----------------------------------------------------------------------------------------------

--displays a question and sets the colour
questionObject = display.newText("", display.contentWidth/3, display.contentHeight/2, nil, 80)
questionObject:setTextColor(27/255, 71/255, 144/255)

--displays the points and sets the colour
pointsObject = display.newText("", 500, 250, Arial, 50)
pointsObject:setTextColor(27/255, 144/255, 35/255)

--create the correct text object and make it invisible
correctObject = display.newText("Correct!", display.contentWidth/2, display.contentHeight*2/3, nil, 50)
correctObject:setTextColor(27/255, 144/255, 35/255)
correctObject.isVisible = false

--create the correct text object and make it invisible
incorrectObject = display.newText("Incorrect", display.contentWidth/2, display.contentHeight*2/3, nil, 50)
incorrectObject:setTextColor(1, 0, 0)
incorrectObject.isVisible = false

--create numeric field
numericField = native.newTextField(600, display.contentHeight/2, 200, 100)
numericField.inputType = "number"

--add the event listener for the numeric field
numericField:addEventListener("userInput", NumericFieldListener)

--create the lives to display on the screen
heart1 = display.newImageRect("Images/heart.png", 100, 100)
heart1.x = display.contentWidth * 7 / 8
heart1.y = display.contentHeight * 1 / 7

heart2 = display.newImageRect("Images/heart.png", 100, 100)
heart2.x = display.contentWidth * 6 / 8
heart2.y = display.contentHeight * 1 / 7

heart3 = display.newImageRect("Images/heart.png", 100, 100)
heart3.x = display.contentWidth * 5 / 8
heart3.y = display.contentHeight * 1 / 7

--display the timer
clockText = display.newText("", 100, 100, Arial,70)
clockText:setTextColor(114/255, 32/255, 27/255)

--create a game over scene
gameOver = display.newImageRect("Images/gameOver.png", 1100, 1100)
gameOver.x = 500
gameOver.y = 400
gameOver.isVisible = false

--create a winner scene
winner = display.newImageRect("Images/winner.jpg", 1100, 800)
winner.x = 500
winner.y = 400
winner.isVisible = false

--create text that says the correct answer to a question
correctText = display.newText("", 500, 600, Arial, 50)
correctText:setTextColor(13/255, 130/255, 190/255)



----------------------------------------------------------------------------------------------
--FUNCTION CALLS
----------------------------------------------------------------------------------------------

--call the function to ask the question
AskQuestion()

--call the function to update the time
UpdateTime()

--call the function to start the timer
StartTimer()