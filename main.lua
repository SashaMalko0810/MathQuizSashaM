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
local lives = 5
local heart1
local heart2
local heart3
local heart4
local gameOver
local gameOverSound = audio.loadSound("Sounds/GameOver.mp3")
local gameOverSoundChannel
local divide

----------------------------------------------------------------------------------------------
--LOCAL FUNCTIONS
----------------------------------------------------------------------------------------------

local function AskQuestion()
	--generate 2 random numbers between a max. and a min. number
	randomNumber1 = math.random(1,20)
	randomNumber2 = math.random(1,20)
	randomNumber3 = math.random(1,10)
	randomNumber4 = math.random(1,10)
	randomNumber5 = math.random(1,20)
	randomNumber6 = math.random(1,20)
    randomOperator = math.random(1,4) 
    randomOperator = 4 

    
    --display the points on the screen 
    pointsObject.text = "Points" .. " = ".. points
   
   	-- 
    if (randomOperator == 1) then
    	correctAnswer = randomNumber1 + randomNumber2
	
		--create question in text object
		questionObject.text = randomNumber1 .. "+" .. randomNumber2 .. "="

	-- 
    elseif (randomOperator == 2) then 
	   correctAnswer = randomNumber1 - randomNumber2
	
	   --create a question in text object
       questionObject.text = randomNumber1 .. "-" .. randomNumber2 .. "="
     

      	if (correctAnswer < 0) then 
        	correctAnswer = randomNumber2 - randomNumber1
      
         	--create a question in text object
         	questionObject.text = randomNumber2 .. "-" .. randomNumber1 .. "="
    	end 

    elseif (randomOperator == 3) then 
		correctAnswer = randomNumber3 * randomNumber4

		--create question in text object
		questionObject.text = randomNumber3 .. "*" .. randomNumber4 .. "="

    elseif (randomOperator == 4) then
    	correctAnswer = randomNumber5 / randomNumber6

        if (correctAnswer > 0) then
    		correctAnswer = randomNumber5 * randomNumber6
    		divide = correctAnswer / randomNumber5 
    	end
	
		--create question in text object
		questionObject.text = correctAnswer .. "/" .. randomNumber5 .. "="
	end
end

local function HideCorrect()
	correctObject.isVisible = false
	AskQuestion()
end

local function HideIncorrect()
	incorrectObject.isVisible = false
	AskQuestion()
end

local function NumericFieldListener(event)

	--user begins editing "numericField"
	if (event.phase == "began") then

		--clear text field
		event.target.text = ""

	elseif event.phase == "submitted" then

		--when the answer is sumbitted (enter key is pressed) set user input to user's answer
		userAnswer = tonumber(event.target.text)

		--if the user's answer and the correct answer are the same:
		if (userAnswer == correctAnswer) then
			correctObject.isVisible = true
			incorrectObject.isVisible = false
			timer.performWithDelay(1000,HideCorrect)
			points = points + 1
			pointsObject.text = "Points" .. " = ".. points
			
            elseif (userAnswer) then
			correctObject.isVisible = false
			incorrectObject.isVisible = true
			timer.performWithDelay(1000,HideIncorrect)
			lives = lives - 1
        if (lives == 4) then
	    	heart4.isVisible = false
        elseif (lives == 3) then
	    	heart3.isVisible = false
	    	elseif (lives == 2) then 
	    		heart2.isVisible = false
	    		elseif (lives == 1) then
	    			heart1.isVisible = false
	    			gameOver.isVisible = true	
	    			numericField.isVisible = false
	    			clockText.isVisible = false
	    			gameOverSoundChannel = audio.play(gameOverSound)
	        end 
	    
	    --clear text field
		event.target.text = ""
		
		end
	end
end

local function UpdateTime()

	--decrement the number of seconds
	secondsLeft = secondsLeft - 1

	--display the number of seconds left in the clock object
	clockText.text = secondsLeft .. "" 

	if (secondsLeft == 0) then
		--reset the number of seconds left
		secondsLeft = totalSeconds
	    lives = lives - 1
	    AskQuestion()

	    if (lives == 4) then
	    	heart4.isVisible = false
        elseif (lives == 3) then
	    	heart3.isVisible = false
	    	elseif (lives == 2) then 
	    		heart2.isVisible = false
	    		elseif (lives == 1) then
	    			heart1.isVisible = false
	    			gameOver.isVisible = true
	    			numericField.isVisible = false
	    			clockText.isVisible = false
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

heart4 = display.newImageRect("Images/heart.png", 100, 100)
heart4.x = display.contentWidth * 4 / 8
heart4.y = display.contentHeight * 1 / 7

--display the timer
clockText = display.newText("", 100, 100, Arial,70)
clockText:setTextColor(114/255, 32/255, 27/255)

--create a game over scene
gameOver = display.newImageRect("Images/gameOver.png", 1100, 1100)
gameOver.x = 500
gameOver.y = 400
gameOver.isVisible = false


----------------------------------------------------------------------------------------------
--FUNCTION CALLS
----------------------------------------------------------------------------------------------

--call the function to ask the question
AskQuestion()

--call the function to update the time
UpdateTime()

--call the function to start the timer
StartTimer()