
Feature: Subscribers see different articles based on their subscription level 

Background: 
Given users are:   
| Email                   | Password          | Subscription   |
| freeFrieda@example.com  | validPassword123  | Free           |
| paidPattya@example.com  | validPassword123  | Paid           |
And articles are: 
| Title          | Type  |
| Free Article1  | Free  |
| PaidArticle1   | Paid  |

Scenario: Free subscribers see only the free articles
When user logs in: 
| Email     | paidPattya@example.com  |
Then home page displays: 
| Free Article1  | 
| PaidArticle1   | 

Scenario: Domain Term Subscription 
* Subscription values are: 
| Free | 
| Paid | 

Scenario: Domain Term Article Type 
* Article Types are:
| Free | 
| Paid | 

Scenario: Subscriber with a paid subscription can access both free and paid articles
When user logs in: 
| Email     | freeFrieda@example.com  |
Then home page displays: 
| Free Article1  | 

Scenario: 
Scenario: Free subscribers see only the free articles
  Given users with a free subscription can access "FreeArticle1" but not "PaidArticle1" 
  When I type "freeFrieda@example.com" in the email field
  And I type "validPassword123" in the password field
  And I press the "Submit" button
  Then I see "FreeArticle1" on the home page
  And I do not see "PaidArticle1" on the home page

Scenario: Subscriber with a paid subscription can access "FreeArticle1" and "PaidArticle1"
  Given I am on the login page
  When I type "paidPattya@example.com" in the email field
  And I type "validPassword123" in the password field
  And I press the "Submit" button
  Then I see "FreeArticle1" and "PaidArticle1" on the home page  
 
Scenario: Free subscribers see only the free articles
  Given Free Frieda has a free subscription
  When Free Frieda logs in with her valid credentials
  Then she sees a Free article

Scenario: Subscriber with a paid subscription can access both free and paid articles
  Given Paid Patty has a basic-level paid subscription
  When Paid Patty logs in with her valid credentials
  Then she sees a Free article and a Paid article