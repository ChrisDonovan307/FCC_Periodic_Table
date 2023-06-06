#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1

# if there is no input
if [[ ! -z $INPUT ]]
then
  # if $INPUT is a number
  if [[ $INPUT = [0-9]* ]]
  then
    # check if it is in database
    SEARCH_RESULT=$($PSQL "SELECT name FROM elements WHERE atomic_number = '$INPUT';")
    if [[ -z $SEARCH_RESULT ]]
    then
      echo 'I could not find that element in the database.'
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$INPUT';")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$INPUT';")
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = '$INPUT';")
      IS_METALLIC=$($PSQL "SELECT type FROM types INNER JOIN properties USING (type_id) WHERE atomic_number = $INPUT;")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$INPUT';")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$INPUT';")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$INPUT';")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $IS_METALLIC, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  else
    # if $INPUT is not a number
    if [[ ! $INPUT =~ ^[0-9]+$ ]]
    then
      # if input is 2 or fewer characters
      if [[ ${#INPUT} -le 2 ]]
      then
        # then it's a symbol
        # check if it is in database
        SEARCH_RESULT=$($PSQL "SELECT name FROM elements WHERE symbol = '$INPUT';")
        if [[ -z $SEARCH_RESULT ]]
        then
          echo 'I could not find that element in the database.'
        else
          # get all our vars here
          ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT';")
          SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$INPUT';")
          NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$INPUT';")
          IS_METALLIC=$($PSQL "SELECT type FROM types INNER JOIN properties USING (type_id) INNER JOIN elements USING (atomic_number) WHERE symbol = '$INPUT';")
          ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM types INNER JOIN properties USING (type_id) INNER JOIN elements USING (atomic_number) WHERE symbol = '$INPUT';")
          MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM types INNER JOIN properties USING (type_id) INNER JOIN elements USING (atomic_number) WHERE symbol = '$INPUT';")
          BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM types INNER JOIN properties USING (type_id) INNER JOIN elements USING (atomic_number) WHERE symbol = '$INPUT';")
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $IS_METALLIC, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
      else
        # then input must be a name
        # check if it is in database
        SEARCH_RESULT=$($PSQL "SELECT symbol FROM elements WHERE name = '$INPUT';")
        if [[ -z $SEARCH_RESULT ]]
        then
          echo 'I could not find that element in the database.'
        else
          ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$INPUT';")
          SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$INPUT';")
          NAME=$($PSQL "SELECT name FROM elements WHERE name = '$INPUT';")
          IS_METALLIC=$($PSQL "SELECT type FROM types INNER JOIN properties USING (type_id) INNER JOIN elements USING (atomic_number) WHERE name = '$INPUT';")
          ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM types INNER JOIN properties USING (type_id) INNER JOIN elements USING (atomic_number) WHERE name = '$INPUT';")
          MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM types INNER JOIN properties USING (type_id) INNER JOIN elements USING (atomic_number) WHERE name = '$INPUT';")
          BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM types INNER JOIN properties USING (type_id) INNER JOIN elements USING (atomic_number) WHERE name = '$INPUT';")
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $IS_METALLIC, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi    
      fi
    fi
  fi
else
  echo 'Please provide an element as an argument.'
fi
