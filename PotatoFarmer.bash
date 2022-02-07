#!/bin/bash

#PotatoFarmer.bash
#Phillip Ball
#07/16/2021 / 07/19/2021
#A farming simulator I built to learn Bash.
#The player can plant and visit a shop screen to buy potato seeds, harvest/sell potatoes which raises their score and the player can cycle "days" to grow the potato seeds into potatoes.

#Variables for inventory and fields for planting
money=500
seedPrice=50
sellHarvestPrice=100
score=0
numOfSeeds=5
daysToGrow=3
rowArray1=("X" "X" "X" "X" "X")
rowArray2=("X" "X" "X" "X" "X")
rowArray3=("X" "X" "X" "X" "X")
row1DaysPlanted=(0 0 0 0 0)
row2DaysPlanted=(0 0 0 0 0)
row3DaysPlanted=(0 0 0 0 0)

#Logic for planting potatoes
plantPotato() {
    #Check if the player has any potato seeds
    echo "______________"
    if [[ numOfSeeds -gt 0 ]]; then
        #Variable used to determine whether a potato was planted or not
        openRowFinder=0
        #Checks for an open spot in row 1, if found plants potato
        for ((spot=0; spot<"${#rowArray1[@]}"; spot++ )); do
            if [[ "${rowArray1[$spot]}" == "X" ]]; then
                rowArray1[$spot]="O"
                openRowFinder=1
                break
            fi
        done
        #Checks for an open spot in row 2, if found plants potato
        if [[ openRowFinder -eq 0 ]]; then
            for ((spot=0; spot<"${#rowArray2[@]}"; spot++ )); do
                if [[ "${rowArray2[$spot]}" == "X" ]]; then
                    rowArray2[$spot]="O"
                    openRowFinder=1
                    break
                fi
            done
        fi
        #Checks for an open spot in row 3, if found plants potato
        if [[ openRowFinder -eq 0 ]]; then
            for ((spot=0; spot<"${#rowArray3[@]}"; spot++ )); do
                if [[ "${rowArray3[$spot]}" == "X" ]]; then
                    rowArray3[$spot]="O"
                    openRowFinder=1
                    break
                fi
            done
        fi
        if [[ openRowFinder -eq 0 ]]; then
            echo "Looks like you don't have anymore room for potatoes, sorry!"
        else
            echo "A potato has been planted!"
            let "numOfSeeds-=1"
        fi
    else
        echo "You're out of potato seeds!"
    fi
    
    gameScreen
}

harvestPotato() {
    #Variable used to determine how many potatoes were harvested
    harvested=0
    
    #logic for harvesting potatoes
    for ((spot="${#row1DaysPlanted[@]}"-1; spot>-1; spot-- )); do
        if [[ "${row1DaysPlanted[$spot]}" -ge daysToGrow ]]; then
            let "harvested+=1"
            rowArray1[$spot]="X"
            row1DaysPlanted[$spot]=0
            let "score+=1"
        fi
    done
    for ((spot="${#row2DaysPlanted[@]}"-1; spot>-1; spot-- )); do
        if [[ "${row2DaysPlanted[$spot]}" -ge daysToGrow ]]; then
            let "harvested+=1"
            rowArray2[$spot]="X"
            row2DaysPlanted[$spot]=0
            let "score+=1"
        fi
    done
    for ((spot="${#row3DaysPlanted[@]}"-1; spot>-1; spot-- )); do
        if [[ "${row3DaysPlanted[$spot]}" -ge daysToGrow ]]; then
            let "harvested+=1"
            rowArray3[$spot]="X"
            row3DaysPlanted[$spot]=0
            let "score+=1"
        fi
    done

    echo "______________"
    if [[ harvested -eq 0 ]]; then
        echo "Doesn't look like any potatoes are ready for harvest yet, sorry!"
    else
        let pay=$sellHarvestPrice*$harvested
        echo "You harvested all harvestable potatoes!"
        echo "You earned $pay$ worth of potatoes. Great job!"
        let "money+=pay"
    fi
    
    gameScreen
}

goToShop() {
    #Shop menu
    echo "______________"
    echo "  _____  "
    echo " /     \ "
    echo "[_]---[_]"
    echo " \  d  / "
    echo "  |___|  "
    echo "  \___/  "
    echo "Hey there!"
    echo "The potato seeds are $seedPrice$ each."
    echo "So, ya here to buy?"
    echo "_________"
    echo "1: Buy"
    echo "2: Leave"
    echo "Type the associated number and then press enter to choose."
    
    #Seed buying menu
    while [[ $answer -ne 1 || $answer -ne 2 ]]; do
        read answer
        echo "______________"
        if [[ $answer == 1 ]]; then
            echo "How many would you like to buy?"
            echo "1: 1 seed please!"
            echo "2: 5 seeds please!"
            echo "3: Back"
            echo "Type the associated number and then press enter to choose."
            
            #Purchasing logic
            while [[ $answer -ne 1 || $answer -ne 2 || $answer -ne 3 ]]; do
                read answer
                echo "______________"
                if [[ $answer == 1 ]]; then
                    if [[ $money -lt $seedPrice ]]; then
                        echo "Looks like you're short on funds. Get more by harvesting the potatoes you already have, they should be grown after a few days!"
                    else
                        echo "Thank you for increasing the number of potatoes in the world!"
                        let "money-=seedPrice"
                        let "numOfSeeds+=1"
                    fi
                elif [[ $answer == 2 ]]; then
                    if [[ $money -lt seedPrice*5 ]]; then
                        echo "Looks like you're short on funds. Get more by harvesting the potatoes you already have, they should be grown after a few days!"
                    else
                        echo "Thank you for increasing the number of potatoes in the world!"
                        let "money-=seedPrice*5"
                        let "numOfSeeds+=5"
                    fi
                elif [[ $answer == 3 ]]; then
                    echo "Well alright, come on back when you need more seeds!"
                    gameScreen
                    break
                else
                    echo "Please give one of the 3 choices."
                fi
            done
        elif [[ $answer == 2 ]]; then
            echo "Well alright, come on back when you need more seeds!"
            gameScreen
            break
        else
            echo "Please give one of the 2 choices."
        fi
    done
}

nextDay() {
    #Variable to determine if there's potatoes ready for harvest
    readyToHarvest=0
    slept=0
    
    #Logic for cycling potato growth
    for ((spot=0; spot<"${#rowArray1[@]}"; spot++ )); do
        if [[ "${rowArray1[$spot]}" == "O" ]]; then
            let "row1DaysPlanted[$spot]+=1"
            let "slept+=1"
            if [[ row1DaysPlanted[$spot] -ge daysToGrow ]]; then
                let "readyToHarvest+=1"
                #Makes it so the user can't get the days planted insainly large
                row1DaysPlanted[$spot]=daysToGrow
            fi
        fi
    done
    for ((spot=0; spot<"${#rowArray2[@]}"; spot++ )); do
        if [[ "${rowArray2[$spot]}" == "O" ]]; then
            let "row2DaysPlanted[$spot]+=1"
            let "slept+=1"
            if [[ row2DaysPlanted[$spot] -ge daysToGrow ]]; then
                let "readyToHarvest+=1"
                #Makes it so the user can't get the days planted insainly large
                row2DaysPlanted[$spot]=daysToGrow
            fi
        fi
    done
    for ((spot=0; spot<"${#rowArray3[@]}"; spot++ )); do
        if [[ "${rowArray3[$spot]}" == "O" ]]; then
            let "row3DaysPlanted[$spot]+=1"
            let "slept+=1"
            if [[ row3DaysPlanted[$spot] -ge daysToGrow ]]; then
                let "readyToHarvest+=1"
                #Makes it so the user can't get the days planted insainly large
                row3DaysPlanted[$spot]=daysToGrow
            fi
        fi
    done
    
    echo "______________"
    if [[ slept -gt 0 ]]; then
        echo "ZZZ..."
        echo "The planted potatoes have grown some more!"
        
        if [[ readyToHarvest -gt 0 ]]; then
            echo "There's some full grown potatos!"
            echo "Time to harvest!"
        fi
    else
        echo "What are you thinking?! There's no time to rest!"
        echo "Get out there and plant some potatoes!"
    fi
    
    gameScreen
}

#The primary image for the player to see (the players farm)
gameScreen() {
    #These three forloops build out the fields for planting
    #It does it this way so that the fields will update as
    #the player plants potatoes
    row1=()
    row2=()
    row3=()
    for (( spot=0; spot<"${#rowArray1[@]}"; spot++)); do
        row1="${row1}${rowArray1[$spot]}"
    done
    for (( spot=0; spot<"${#rowArray2[@]}"; spot++)); do
        row2="${row2}${rowArray2[$spot]}"
    done
    for (( spot=0; spot<"${#rowArray3[@]}"; spot++)); do
        row3="${row3}${rowArray3[$spot]}"
    done
    
    #The actual display
    echo "______________"
    echo "--||----------"
    echo "  ||  __      "
    echo "  ||  []  {}  "
    echo "   ==    ====="
    echo "WWWW  || $row1"
    echo " WW   || $row2"
    echo "  WWW || $row3"
    echo "------||------"
    echo "______________"
    echo "Inventory:"
    echo "$money$ Seeds: $numOfSeeds"
    echo "Potato Score: $score"
    echo "______________"
    
    #The players options as to what to do
    echo "What would you like to do?"
    echo "1: Plant Potatoes"
    echo "2: Harvest Potatoes"
    echo "3: Go to the Shop"
    echo "4: Sleep"
    echo "5: Exit Game"
    echo "Type the associated number and then press enter to choose."
    
    #Logic for the players options
    while [[ $answer -ne 1 || $answer -ne 2 || $answer -ne 3 || $answer -ne 4 || $answer -ne 5 ]]; do
        read answer
        if [[ $answer == 1 ]]; then
            plantPotato
            break
        elif [[ $answer == 2 ]]; then
            harvestPotato
            break
        elif [[ $answer == 3 ]]; then
            goToShop
            break
        elif [[ $answer == 4 ]]; then
            nextDay
            break
        elif [[ $answer == 5 ]]; then
            exit
        else
            echo "Please give one of the 5 choices."
        fi
    done
}

#The main menu of the game
mainMenu() {
    #Intro
    echo "Welcome to Potato Farmer!"
    echo "1: Start Game"
    echo "2: Exit"
    echo "Type the associated number and then press enter to choose."
        
    #Logic for intro options
    while [[ $answer -ne 1 || answer -ne 2 ]]; do
        read answer
        if [[ $answer == 1 ]]; then
            gameScreen
            break
        elif [[ $answer == 2 ]]; then
            exit
        else
            echo "Please give one of the 2 choices."
        fi
    done
}

mainMenu