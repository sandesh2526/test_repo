#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=game -t -c"

#generating random number between 1-1000
RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))
#Heart of game logic
GAME() {
	NUMBER_OF_GUESSES=1
	echo "Guess the secret number between 1 and 1000:"
	read GUESS
	while [[ $GUESS -ne $RANDOM_NUMBER ]]
	do
		if [[ $GUESS =~ ^[0-9]+$ ]]
		then
			if [[ $GUESS -gt $RANDOM_NUMBER ]]
			then
				echo "It's lower than that, guess again:"
			else
				echo "It's higher than that, guess again:"
			fi
		else
			echo "That is not an integer, guess again:"		
		fi
		NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES+1 )) 
		read GUESS
	done
}

#get user input for username
echo "Enter your username: "
read USERNAME
#check user in database
USER=$($PSQL "SELECT * FROM userstats WHERE username='$USERNAME'")
#if not exist
if [[ -z $USER ]]
then
	echo "Welcome, $USERNAME! It looks like this is your first time here."
	#add in the database
	INSERT_USER=$($PSQL "INSERT INTO userstats(username) VALUES('$USERNAME')")
else
	echo $USER | while read USERNAME BAR GAMES_PLAYED BAR BEST_GAME
	do
		echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
	done
fi

#main_game
GAME

#Update the database, if it is best game set new best game else only change the games played 
echo $($PSQL "SELECT games_played,best_game FROM userstats WHERE username='$USERNAME'") | while read GAMES_PLAYED BAR BEST_GAME #"GAMES_PLAYED: $GAMES_PLAYED"
do
	GAMES_PLAYED=$(( $GAMES_PLAYED + 1 ))
	if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
	then
		FINAL_RESULT=$($PSQL "UPDATE userstats SET games_played=$GAMES_PLAYED,best_game=$NUMBER_OF_GUESSES WHERE username='$USERNAME'")
	else
		FINAL_RESULT=$($PSQL "UPDATE userstats SET games_played=$GAMES_PLAYED WHERE username='$USERNAME'")
	fi	
	echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"
done
