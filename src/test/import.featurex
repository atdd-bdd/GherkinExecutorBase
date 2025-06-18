Feature: Import

# creates the import statements for all the files (including the data files) 

Import 
| Datatype    | ConversionMethod    | Import                   | Notes                 |
| Pattern     | Pattern.compile($)  | java.util.regex.Pattern  |                       |
| Weekday     | Weekday.valueOf($)  |                          | Enum that is created  |
| BigInteger  | new BigInteger($)   | java.math.BigInteger     |                       |

Data ImportData 
| Name       | Default             | Datatype    | Notes           |
| myPattern  | a.*                 | Pattern     | Uses a pattern  |
| myWeekday  | MONDAY              | Weekday     | Uses an enum    |
| myBigInt   | 1                   | BigInteger  | Uses import     |


Scenario: Use an import
Given this data should be okay # ListOfObject ImportData 
| myPattern  | myWeekday  | myBigInt     |
| a.*        | MONDAY     | 1            |
| [ab]       | SUNDAY     | 10000000000  |


Scenario: Should fail 
Given this data should fail # ListOfObject ImportData 
| myPattern  | myWeekday  | myBigInt  |
| a.*        | SOMEONE    | 1         |
| [ab]       | SUNDAY     | 2         |

Scenario: Should also fail
Given this data should fail # ListOfObject ImportData 
| myPattern  | myWeekday  | myBigInt  |
| a.*        | MONDAY     | 1         |
| [ab]       | SUNDAY     | A.2       |


