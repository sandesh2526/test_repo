#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"
PRINT_ELEMENT_INFO(){
	if [[ ! $1 =~ ^[0-9]+$ ]]
	then
		ELEMENT=$($PSQL "SELECT atomic_number,symbol,name,types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1' OR symbol='$1'")
		if [[ ! -z $ELEMENT ]]
		then
			echo "$ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
			do
				echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
			done
		else
			echo "I could not find that element in the database."
		fi	
	else
		ELEMENT=$($PSQL "SELECT atomic_number,symbol,name,types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number='$1'")
		if [[ ! -z $ELEMENT ]]
		then
			echo "$ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
			do
				echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
			done
		else
			echo "I could not find that element in the database."
		fi	
	fi
}

if [[ $1 ]]
then
	PRINT_ELEMENT_INFO $1
else
	echo "Please provide an element as an argument."
fi
