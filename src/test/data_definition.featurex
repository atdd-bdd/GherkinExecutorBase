Feature: Data Definition


Scenario Simple Comparison 
Given table is # ListOfObject ATest 
| anInt  | aString    | aDouble  |
| 1      | something  | 1.2      |
When compared to # ListOfObject ATest Compare 
| aString    | 
| something  | 
Then result is 
| true | 
When compared to # ListOfObject ATest Compare 
| aString         | 
| something else  | 
Then result is 
| false| 


# will create an internal class name 
Data ATest 
| Name     | Default  | Datatype  | Note  |
| anInt    | 0        | Int       |       |
| aString  | ~        | String    |       |
| aDouble  | 4.0      | Double    |       |

# will create a .tmpl file for Existing 

Data TestIn Existing 
| Name    | Default  | Datatype  | Note  |
| aValue  | 0        | int       |       |
| bValue  | ~        | String    |       |
| cValue  | 4.0      | double    |       |

Data AllTypes
| Name            | Default  | DataType  | Note       |
| anInt           | 0        | int       | primitive  |
| aByte           | 0        | byte      | primitive  |
| AShort          | 0        | short     | primitive  |
| aLong           | 0        | long      | primitive  |
| aFloat          | 0.0      | float     | primitive  |
| aDouble         | 0.0      | double    | primitive  |
| aBool           | false    | boolean   | primitive  |
| aString         |          | String    |            |
| aChar           | 0        | char      | primitive  |
| anIntObject     | 0        | Integer   |            |
| aByteObject     | 0        | Byte      |            |
| aShortObject    | 0        | Short     |            |
| aLongObject     | 0        | Long      |            |
| aFloatObject    | 0.0      | Float     |            |
| aDoubleObject   | 0.0      | Double    |            |
| aBoolObject     | false    | Boolean   |            |
| aCharObject     | 0        | Character |            |




