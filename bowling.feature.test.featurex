Feature: Bowling 

Scenario: Adding a roll 
Given rolls are 
|  5 | 5  | 4  | 5  |  8 | 2  | 10  | 0 | 10 | 10 | 6 | 2| 10 | 4 | 6| 10 | 
When roll is 
| 10 |
Then rolls become 
|  5 | 5  | 4  | 5  |  8 | 2  | 10  | 0 | 10 | 10 | 6 | 2| 10 | 4 | 6| 10 | 10 |

Scenario: Full Game Display and Input
#Note:  one more roll remaining to end the game 
Given rolls are 
|  5 | 5  | 4  | 5  |  8 | 2  | 10  | 0 | 10 | 10 | 6 | 2| 10 | 4 | 6| 10 | 10 |
Then display is
| Image File |
| bowling1.jpg | 
Then input display is:
| Image File |
| input control.jpg | 


Scenario: A Game 
Given rolls are: 
|  5 | 5  | 4  | 5  |  8 | 2  | 10  | 0 | 10 | 10 | 6 | 2| 10 | 4 | 6| 10 | 10 |
Then frame values are 
| 1  | 2  | 3   | 4   | 5   | 6   | 7   | 8   | 9   | 10  |
| 5  | 4  | 8   | 10  | 0   | 10  | 6   | 10  | 4   | 10  |
| 5  | 5  | 2   | 0   | 10  | 6   | 2   | 4   | 6   | 10  |
| 4  | 8  | 10  | 10  | 6   | 2   | 10  | 6   | 10  | 10  |

Given frame values as previous 
Then frame scores and marks are 
| 1   | 2  | 3   | 4   | 5   | 6   | 7  | 8   | 9   | 10  |
| 5   | 4  | 8   | X   | 0   | X   | 6  | X   | 4   | X   |
| /   | 5  | /   |     | /   |     | 2  |     | /   | X   |
|     |    |     |     |     |     |    |     |     |     |
| 14  | 9  | 20  | 20  | 16  | 18  | 8  | 20  | 20  |  20 |

Given scores and marks as previous 
Then display values are 
| 1   | 2   | 3   | 4   | 5   | 6    | 7    | 8    | 9    | 10   |
| 5   | 4   | 8   | X   | 0   | X    | 6    | X    | 4    | X    |
| /   | 5   | /   |     | /   |      | 2    |      | /    | X    |
|     |     |     |     |     |      |      |      |      |      |
| 14  | 23  | 43  | 63  | 83  | 101  | 109  | 129  | 149  | 169  |
And input control is
| Frame      | 10 |
| Roll       | 3  |
| Remaining  | 10 |
And game complete is 
| false | 


Given display values are as previous
Then display is
| Image File |
| bowling.jpg | 

Given input control is as previous 
Then input display is:
| Image File |
| inputControl.jpg | 

Given game complete is as previous 
Then control display is : 
| Image File | 
| gameCompleteControl.jpg |

Scenario: Determine frame values and input control 
When rolls are 
|  3 | 6  | 7  | 3  |  10 | 10  | 10  | 
Then frame values become 
|        | 1  | 2  | 3   | 4   | 5  | 6   | 7  | 8  | 9  | 10  |
| Roll1  | 3  | 7  | 10  | 10  | 10 |     |    |    |    |     |
| Roll2  | 6  | 3  |     |     |    |    |    |    |    |     |
And input control is
| Frame      | 6   |
| Roll       | 1   |
| Remaining  | 10  |
And game complete is 
| false | 

Define 
| Name | Value | Notes |
| TB$  | ~     | Not yet rolled |

Domain Term:  Roll 
* Rolls are 
| Value  | Valid  | Notes                              |
| 0      | true   | gutter ball                        |
| 1      | true   |                                    |
| 2      | true   |                                    |
| 3      | true   |                                    |
| 4      | true   |                                    |
| 5      | true   |                                    |
| 6      | true   |                                    |
| 7      | true   |                                    |
| 8      | true   |                                    |
| 9      | true   |                                    |
| /      | true   | represents remaining pins          |
| X      | true   | represents all pins at once        |
| <      | true   | delete previous roll               |
| TBR    | true   | for internal use - not yet rolled  |

# Have an adder (to add two rolls)   returns value or TBR is not yet determinable 


Scenario: 
Given values for current frame are: 
| Roll1 | 7 | 
| Roll2 }   |
Then next roll is for 
| Roll       | 2  |
| Remaining  | 3  |


# Display rules

Scenario: 
Given next roll is for 
| Frame      | 6   |
| Roll       | 1   |
| Remaining  | 10  |
And game complete is 
| false | 
Then inputs are enabled:
| 0     | 1     | 2     | 3           | 4     | 5     | 6     | 7     | 8     | 9     | 10     | /     | X    |
| true  | true  | true  | true  true  | true  | true  | true  | true  | true  | true  | true   | false | true |
And new game is enabled
| false | 

Given next roll is for 
| Frame      | 6  |
| Roll       | 2  |
| Remaining  | 3  |
And game complete is 
| false | 
Then inputs are enabled:
| 0     | 1     |       | 3     | 4      | 5      | 6      | 7      | 8      | 9      | 10     | /     | X      |
| true  | true  | true  | true  | false  | false  | false  | false  | false  | false  | false  | true  | false  |
And new game is enabled
| false | 

Given next roll is for 
| Frame      | 6  |
| Roll       | 2  |
| Remaining  | 3  |
And inputs are enabled:
| 0     | 1     |       | 3     | 4      | 5      | 6      | 7      | 8      | 9      | 10     | /     | X      |
| true  | true  | true  | true  | false  | false  | false  | false  | false  | false  | false  | true  | false  |
Then inputs return
| 0  | 1  | 2  | 3  | /  |
| 0  | 1  | 2  | 3  | 3  |




Given game complete is 
| true | 
Then inputs are enabled:
| 0      | 1      |        | 3      | 4      | 5      | 6      | 7      | 8      | 9      | 10     | /      | X      |
| false  | false  | false  | false  | false  | false  | false  | false  | false  | false  | false  | false  | false  |
And new game is enabled
| true | 
