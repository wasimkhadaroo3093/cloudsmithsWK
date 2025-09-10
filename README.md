Overview

This project implements a public Salesforce web page (Experience Cloud) where visitors can enter a South African ID number.
It validates the ID, saves a search record, and retrieves banking/public holidays for the year of birth using the Calendarific API.

The project demonstrates:

- Layered Salesforce Apex architecture (UT/DM/EM/SM/WS/LTN).

- LWC frontend styled with South African flag colors.

- Full unit testing with mocked callouts.

Architecture
| Layer                          | Class                       | Responsibility                                         |
| ------------------------------ | --------------------------- | ------------------------------------------------------ |
| **UT (Utility)**               | `UT001_IdNumberUtil`        | SA ID validation (DOB, gender, citizenship, Luhn)      |
| **DM (Data Manager)**          | `DM001_SAIdRecord`          | SOQL/DML for `SAIdRecord__c` with CRUD/FLS enforcement |
| **EM (Entity Manager)**        | `EM001_SAIdRecord`          | Maps decoded ID -> `SAIdRecord__c` object               |
| **SM (Service Manager)**       | `SM001_IdCheckerService`    | Orchestration: decode, save/update, fetch holidays     |
| **WS (Web Service)**           | `WS001_CalendarificService` | REST callout to Calendarific API, parse holidays       |
| **LTN (Lightning Controller)** | `LTN001_IdNumberChecker`    | Exposes `@AuraEnabled` methods to LWC                  |

Frontend:

- LWC csmIdNumberChecker -> Input, validation, info panel, holidays sidebar (scrollable, styled in SA colors).


Data Model

Custom object: SAIdRecord__c

Label: SA ID

- IdNumber__c (Text, 13, Unique, External ID)

- DateOfBirth__c (Date)

- Gender__c (Picklist)

- IsCitizen__c (Checkbox)

- SearchCount__c (Number)


UI/UX

- Info Panel -> Green background, Yellow text, Red border (SA flag colors).

- Holidays Sidebar -> Blue background, holidays displayed in Yellow rows.

- Responsive Layout -> Input + button on left, holidays on right, scrollable inside.


Test Data

Valid IDs
| ID Number     | Birthdate  | Gender | Citizen |
| ------------- | ---------- | ------ | ------- |
| 8001015009087 | 1980-01-01 | Male   | Yes     |
| 9205050008081 | 1992-05-05 | Female | Yes     |
| 7503125801197 | 1975-03-12 | Male   | No      |

Invalid IDs
| ID Number     | Fails Because             |
| ------------- | ------------------------- |
| 9913325009087 | Invalid month/day (13/32) |
| 8002315009087 | Feb 31, invalid date      |
| 8001015009086 | Wrong checksum            |
| 8001015009787 | Invalid citizenship digit |


Unit Tests

- UT001_IdNumberUtil_TEST -> valid/invalid IDs, strict DOB, checksum. Coverage 90%

- DM001_SAIdRecord_TEST -> upsert & query. Coverage 100%

- WS001_CalendarificService_TEST -> mocked API parsing. Coverage 94%

- SM001_IdCheckerService_TEST -> decode & save, fetch holidays. Coverage 84%

- LTN001_IdNumberChecker_TEST -> Apex controller exposed to LWC. Coverage 100%


External API

- Calendarific API

- API Key used: 24c5e86734eb44dc4a962826324a5546e74dc42f

- Endpoint: https://calendarific.com/api/v2/holidays?country=ZA&year={YYYY}&api_key={KEY}


Author
Wasim Khadaroo
