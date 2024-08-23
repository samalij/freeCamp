#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    

    NAME_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $NAME_ID_W ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      NAME_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # Check if the opponent team exists
    NAME_ID_L=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $NAME_ID_L ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      NAME_ID_L=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

     echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $NAME_ID_W, $NAME_ID_L, $WINNER_GOALS, $OPPONENT_GOALS)")"
  fi
done

