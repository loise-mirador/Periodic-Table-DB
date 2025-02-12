#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
SYMBOL=$1

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

else
  if [[ ! $SYMBOL =~ ^[0-9]+$ ]]
  then
    LENGTH=$(echo -n "$SYMBOL" | wc -m)

    if [[ $LENGTH -gt 2 ]]
    then
      # get element by full name
      DATA=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE name='$SYMBOL'")
      
      if [[ -z $DATA ]]
      then
        echo "I could not find that element in the database."

      else
        echo "$DATA" | sed -e 's/^ *//' -e 's/ *$//' -e 's/ *| */|/g' | while IFS="|" read NUMBER SYMBOL NAME WEIGHT MELTING BOILING TYPE
        do
          echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi

    else
      # get element by symbol
      DATA=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$SYMBOL'")
      
      if [[ -z $DATA ]]
      then
        echo "I could not find that element in the database."

      else
        echo "$DATA" | sed -e 's/^ *//' -e 's/ *$//' -e 's/ *| */|/g' | while IFS="|" read NUMBER SYMBOL NAME WEIGHT MELTING BOILING TYPE
        do
          echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi
    fi

  else
    # get element by atomic number
    DATA=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$SYMBOL")
    if [[ -z $DATA ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$DATA" | sed -e 's/^ *//' -e 's/ *$//' -e 's/ *| */|/g' | while IFS="|" read NUMBER SYMBOL NAME WEIGHT MELTING BOILING TYPE
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  fi
fi
