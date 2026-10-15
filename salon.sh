#!/bin/bash

run_query() {
  psql --username=freecodecamp --dbname=salon --tuples-only --no-align --command="$1"
}

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

SERVICES=$(run_query "SELECT service_id || ') ' || name FROM services ORDER BY service_id")
echo "$SERVICES"
echo
read SERVICE_ID_SELECTED

while [[ ! "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]] || [[ -z "$(run_query "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")" ]]; do
  echo -e "\nI could not find that service. What would you like today?"
  echo "$SERVICES"
  echo
  read SERVICE_ID_SELECTED
done

SERVICE_NAME=$(run_query "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME=$(run_query "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z "$CUSTOMER_NAME" ]]; then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  run_query "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')" >/dev/null
fi

echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

CUSTOMER_ID=$(run_query "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
run_query "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')" >/dev/null

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."