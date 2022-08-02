-- Keep a log of any SQL queries you execute as you solve the mystery.
-- To find the crime which took place on July 28, 2021 and that it took place on Humphrey Street.
SELECT * FROM crime_scene_reports WHERE street = "Humprey Street" AND day = "28";
-- Theft took place at 10:15am. Three witnesses mentioned bakery in their interview transcript.
-- We read their interview transcripts.
SELECT * FROM interviews WHERE month = "7" AND day = "28";

-- With Ruth's Interview we check bakery security log at exit within ten minutes of incident.
SELECT name AS people_exiting_bakery FROM people WHERE license_plate IN (
    SELECT license_plate FROM bakery_security_logs WHERE day = "28" AND hour = "10" AND minute >= "15" AND minute <= "25") ORDER BY name;

-- Raymond said thief talked to someone for less than a minute, we find out names of the callers using people table.
SELECT name as people_who_called FROM people WHERE phone_number IN (
    SELECT caller FROM phone_calls WHERE day = "28" AND month = "7" AND duration < "60") ORDER BY name;

--Raymond said they are booking flight for tomorrow.
SELECT id FROM flights WHERE origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville") AND day = "29" ORDER BY hour LIMIT 1;
--flight id 36 came out to be the earliest flight at 8 20 am on 29th July from fiftyville to New York City.
-- To extract information of passengers we check with flight_id 36 and then from people list we find out name of those passengers using their passports.
SELECT name as people_who_booked_flight FROM people JOIN passengers
ON passengers.passport_number = people.passport_number WHERE flight_id  = "36" ORDER BY name;


-- With Eugene's Interview we check the atm withdrawals at Leggett Street before Eugene's arrival.
-- Using bank  account and people id we find out name of people who withdrew money.
SELECT name as people_who_withdrew FROM people
JOIN bank_accounts ON bank_accounts.person_id = people.id
JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
WHERE atm_location = "Leggett Street" AND day = "28" AND transaction_type = "withdraw" ORDER BY name;


--intersecting all four cases and figuring theif is Bruce
SELECT name AS Theif FROM people WHERE license_plate IN (
    SELECT license_plate FROM bakery_security_logs WHERE day = "28" AND hour = "10" AND minute >= "15" AND minute <= "25") AND phone_number IN (
    SELECT caller FROM phone_calls WHERE day = "28" AND month = "7" AND duration < "60") AND name IN (
        SELECT name as people_who_booked_flight FROM people JOIN passengers ON passengers.passport_number = people.passport_number WHERE flight_id  = "36")
        AND name IN (SELECT name as people_who_withdrew FROM people
JOIN bank_accounts ON bank_accounts.person_id = people.id
JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
WHERE atm_location = "Leggett Street" AND day = "28" AND transaction_type = "withdraw");

-- for his flight location
SELECT city AS Theif_Escaped_To FROM people
JOIN passengers ON passengers.passport_number = people.passport_number
JOIN flights ON flights.id = passengers.flight_id
JOIN airports ON flights.destination_airport_id = airports.id WHERE flight_id  = "36" AND name = "Bruce";

--Accomplice is one whom Bruce called
SELECT name AS ACCOMPLICE FROM people WHERE phone_number IN (
    SELECT receiver FROM phone_calls WHERE day = "28" AND month = "7" AND duration < "60" AND caller IN (
        SELECT phone_number from people WHERE name = "Bruce"));