# How It Works in Detail

Here is more information on how the statements in GherkinExecutor work. 

### Data Statement

The Data statement describes the fields of a table. 

```
Data LabelValue
| Name   | Default  | DataType  | Notes  |
| Label  |          | String    |        |
| Value  | 0        | Integer   |        |
```

 For example, this 
statement states there are two fields in `LabelValue`.  `

- ``Label` is a string field with the empty string as the default value. 

- `Value` is a `Integer with 0 as the default value.   

You can use any primitive (int, float, etc.)
or associated class (Integer, Float, etc.) as the DataType. If you have an `Import` statement or 
add import in Configuration,  then you can use the data types in those packages.   
 The notes are just there to give any additional information for the field. 

If you favor Abstract Data Types, e.g. `ID`, `State`. you can use them
as a data type.  If they have a String constructor (e.g. `ID(String value))`
you can use it in the Data statement without any additional statement.  If the type requires an import from
the production package, include that import in the Configuration. 
If the creation of an object requires a different form (e.g.` parse(String`))
you will need to create an `Import` statement and identify the method that turns a string into an object.    

Now what does  this Data statement do for you?   One or two classes 
are created.  One is the name you have specified (e.g. `LabelValue`) 
All attributes will be of the String type.  It will have an 
all attribute constructor, a` toString(), an equals()`, and a builder set of
methods.   The latter is used to initialize objects in the test class.

If you have more than two columns (e.g. specified the DataType), a
second class will be created with attributes of the same names, but with
the data types specified. (I refer to this as the internal class or object - as 
it is used internally for computation.) This second class will have a constructor 
with all attributes as parameters, a `toString(), an equals(),` and a method 
to convert it to the object with all strings.  It also has a static method
that displays the data types (for usage in error messages).   

If the second class is created, the first class will also have a method
to convert it to the internal class.  It's possible there is an invalid
value in the table for a particular DataType, so you may wish to catch IllegalArgumentException in the glue code or just let the test handle it

The sample templates for the glue code loop through the list of objects 
and convert each one to an internal object.  

### Existing Classes

Suppose you already had an existing class that you are going to use
in calling the production code from the glue code.  
If you specify a name of a class as the second value in the Data statement, 
then an internal class is not created.  (A file that matches what would
be created is in a .tmpl file). 

There will be a `to` method in the string class that creates the 
internal class.   It will pass the attributes to the internal class constructor in 
the order they are listed in the Data statement.   

```
Data LabelValueString LabelValue
| Name   | Default  | DataType  | Notes  |
| Label  |          | String    |        |
| Value  | 0        | Integer   |        |
```

### Special equals

The `equals()` that is created for the string class is slightly different from 
the normal equals, which just compares all attributes.  If either
of the values being compared is `"?DNC?",` the values are not compared. 
(This can be set to something else in the Configuration.)    

How does it get to become` "?DNC?`"? You could set it manually. Or 
you could use an option on the` ListOfObject` for a table. If you specify 
`compare`, when there are fewer columns than attributes of the data, 
the fields not specified will be set to` '?DNC?`'.

```
* A table to List of Object with Defaults # ListOfObject ExampleClass compare
  | FieldA  |
  | a       |
  | c       |
```

Let's take a look at the Data statement again. Here's the example:  

```
Data FandC

| Name   | Default  | DataType  | Notes  |
| F      | 0        | Integer   |        |
| C      | 0        | Integer   |        |
| Notes  |          | String    |        |
```

To simplify creation of the objects in a table, you create a Data statement which describes the attributes.
Since the `DataType` field is specified, this statement creates two classes, each in their own file.  The first class 
has all attributes as data type String.  This is referred to as the string object.   
Objects of this type are created in the test file and passed to the glue methods.   The second class has the same
names for the attributes but the data types are those listed (e.g. `Integer`).  This second class has `Internal` appended 
to the name (`FandCInternal`

Note:  These files are recreated every time Translate runs.  If you need to import a package, your can add it to the Configuration
or use an `Import` statement.  Here's an example of the `FandC` class: 

```
package gherkinexecutor.Feature_Examples;
class FandC{
    String f = "0";
    String c = "0";
    String notes = "";
    public FandC() { }
    public FandC(
        String f     ,String c     ,String notes){
        this.f = f;
        this.c = c;
        this.notes = notes;
        }
    @Override
    public boolean equals (Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FandC _FandC = (FandC) o;
         if (
             !this.f.equals("?DNC?")
                && !_FandC.f.equals("?DNC?"))
                if (!_FandC.f.equals(this.f)) return false; 
             // and 2 more clauses
                     return true;  }
    public static class Builder {
        // builder methods
        public Builder  setCompare() {
            f = "?DNC?";
            c = "?DNC?";
            notes = "?DNC?";
            return this;
            }
    @Override
    public String toString() {
        // toString cod 

    FandCInternal toFandCInternal() throws IllegalArgumentException {
        return new FandCInternal(
         Integer.valueOf(f)
        , Integer.valueOf(c)
        , notes
        ); 
    }
```

You'll notice additional clauses in the `equals()` method.  A comparison of two attributes is not 
checked if either contains `$DNC$`.  This allows a comparison between a table which has all its fields (columns)
specified and one that only has a few columns specified.   

This special value can be changed in Configuration.  It is set into the attributes by specifying `compare` in the
comment after a step (e.g. `# ListOfObject FandC compare`).   For example, if this were followed by a table 
with only an `F` column, every `C` attribute. would have `?DNC?` as its value.     

There is a conversion method to the internal object, which calls the appropriate conversion method. For data types
in other packages, you need to specify this conversion method in an `Import` statement, if it is not of the 
form `Constructor(String value)`

The purpose of the internal object is to provide the values in the same data types that the production code expects.   

The internal object class that is created (if you don't specify a second name in the Data statement) looks like:

```
package gherkinexecutor.Feature_Examples;
import java.util.*;
class FandCInternal{
     Integer f;
     Integer c;
     String notes;

    public static String toDataTypeString() {
        return "FandCInternal {"
        +"Integer " 
        +"Integer " 
        +"String " 
            + "} "; }  
    FandC toFandC() {
        return new FandC(
        String.valueOf(f)
        ,String.valueOf(c)
        ,notes
        ); }
    public FandCInternal(
        Integer f         ,Integer c         ,String notes)  {
        this.f = f;
        this.c = c;
        this.notes = notes;
        }
    @Override
    public boolean equals (Object o) {
        // code for equals
    @Override
    public String toString() {
        // code for toString
```

The `toDataTypeString()` method can be used to print out the expected data types, in case of a conversion error. 

In this file, you can add `import` for any other classes your production code might need use by adding it to
the `Configuration`

```
        public static final List<String> linesToAddForDataAndGlue = new ArrayList<>();
        // Imports or other lines to add to data class and glue class
        // Must include  semicolon if needed
        static {
            linesToAddForDataAndGlue.add("import java.util.*;"); // as an example
        }
```

Note that the test file only references the class with all string attributes.  The glue code is the place to
convert the string object  into a `FandCInternal` object using the supplied method.  

### Notes

Note you can have as many fields as you like in the Data statement.  

## Import statement

The `Import` statement is used to show conversion methods for library and custom classes.  It can also specify the 
`import` statements required for the library or custom classes.   Here is an example: 

```
Import 
| Datatype    | ConversionMethod    | Import                   | Notes                 |
| Pattern     | Pattern.compile($)  | java.util.regex.Pattern  |                       |
| Weekday     | Weekday.valueOf($)  |                          | Enum that is created  |
| BigInteger  | new BigInteger($)   | java.math.BigInteger     |                       |
```

You specify the conversion 
method from a String, using `$` to show where the string value goes.  
Under Import, you specify the import statement (`import` and `;` will automatically
be added.)  If you do not specify an import location, then the code 
assumes it will be available without one (e.g. you added to the Configuration file).     

If you use a class other than the primitive equivalents (e.g. Integer),
you may need to include it in `Import`. In particular, if the class does not have a constructor that 
takes a String as its sole parameter.  For example, all `enums` use a `valueOf()` method.  

Note, you should add the production package to the imports in the Configuration
attributes.  That way, it will automatically be put in each of the 
generated files. 

Now you can use any of these data types in a Data statement,e.g.:   

```
Data MyDataClass  
| Name       | Default             | Datatype    | Notes           |
| myPattern  | a.*                 | Pattern     | Uses a pattern  |
| myWeekday  | MONDAY              | Weekday     | Uses an enum    |
| myBigInt   | 1                   | BigInteger  | Uses import     |
```

And the` ListOfObject` looks as any other: 

```
Scenario: Use an import
Given this data # ListOfObject MyDataClass 
| myPattern  | myWeekday  | myBigInt     |
| a.*        | MONDAY     | 1            |
| [ab]       | SUNDAY     | 10000000000  |
```

The conversion method is called in the data classes that are created.  

```
Scenario: This should fail 
Given this data # ListOfObject MyDataClass 
| myPattern  | myWeekday  | myBigInt     |
| a.*        | JANUARY    | 1            |
| [ab]       | SUNDAY     | abc          |
```

## Include Statement

You can include another file in a feature file.  If the file is a `.csv` file, it will be converted to a table.   

```
Feature: Include

Scenario: Some scenario here
Given a string
"""
Include "string.inc"
"""
Then a table
Include "TableExample.csv"
Given a string in base directory 
"""
Include 'string.inc'
"""
```

You can include any text, including `Data` statements 
(useful for reusing common data layouts). 
If you surround the filename with single quotes `'string.inc'`,  the file will be  

### Notes

The included file should not have a `Feature` statement in it.  If it does, a warning will be
generated.  

## Include

You can include another file in a feature file. e generated. If the file is a `.csv` file, it will be converted to a table.   

```
Feature: Include

Scenario: Some scenario here
Given a string
"""
Include "string.inc"
"""
Then a table
Include "TableExample.csv"
Given a string in base directory 
"""
Include 'string.inc'
"""
```

You can include any text, including `Data` statements (useful for reusing common data layouts). 
If you surround the filename with single quotes `'string.inc'`,  the file will be searched for in the `Configuration` value:

```
public static final String featureSubDirectory = "src/test/java/";
```

The included file might have a `Feature` statement in it.  If it does, a warning will be generated.  

## Tables

A table can be passed to the glue code in several ways.   If there 
is no option specified (anything after a  `#`), it will be passed 
as a `List<List<String>`.  If you add the `String` option, the table will be
passed as a single string.  

```
Feature: Tables and Strings
Scenario: Here are table options

* A table to List of List of String   
  | aa  | bb  |
  | cc  | dd  |

* A table to String # String
  | aa  | bb  |
  | cc  | dd  |
```

If you specify `ListOfObject` and a _className_, it will be passed 
as `List<_ClassName_>`  You must have a Data description for that object.  

```
* A table to List of Object # ListOfObject ExampleClass
  | FieldA  | FieldB  |
  | a       | b       |
  | c       | d       |
```

#### Transpose

If you add the keyword `transpose` as the third option, the table will be 
interpreted as the field names being in the first column.   This is 
often useful to distinguish data objects from input objects.  The 
vertical names make it appear in a dialog entry format.  

```
* A table to List of Object # ListOfObject ExampleClass transpose
  | FieldA  | a  | c  |
  | FieldB  | b  | d  |
```

#### Default Fields

Now you do not have to include all the fields from the data class. If
you do not, those fields will be filled in with the default values.   
Also, the fields can appear in any order, not just the order listed in 
the data class.  It is sometimes easier to read if they appear in 
the same order, but it's your option. 

```
* A table to List of Object with Defaults # ListOfObject ExampleClass
  | FieldA  |
  | a       |
  | c       |
```

 The headers do not have to appear in the same order
as the Data lists them. 

### Spaces in a Value

A blank element in a table is translated as the empty string `""`.  
You can put spaces into the table by using the `~` character.  There
will be one space for every `~`. For example:

```
* A table to List of Object with Blanks in Name # ListOfObject ExampleClassWithBlanks
  | Field 1  | Field 2  |
  | ~        | b        |
  | c        | ~        |

Data ExampleClassWithBlanks
| Name     | Default  |
| Field 1  | y        |
| Field 2  | x        |
```

### Alternatives for passing single values

You have two alternatives passing single values to the glue code.  In this
example, the Given uses a ListOfObject.  
The first When and Then, also use ListOfObject 

The When appears like the user might select something to filter on 
and a value for the filter.   

```Name
| Value  | a      |
```

The Then step gives the domain term for the answer 4.

```
Then result # ListOfObject ResultValue
| Sum  |
| 4    |
```

Here's the full Scenario:

```
Scenario: Filter Data Another Way  
# filters data 
Given list of numbers # ListOfObject LabelValue
| Label | Value  |
| a     | 1      |
| b     | 2      |
| a     | 3      |
When filtered by # ListOfObject FilterValue transpose
| Name   | Label  |
| Value  | a      |
Then result # ListOfObject ResultValue 
| Sum  |
| 4    |

Data FilterValue 
| Name   | Default  | DataType  | Notes  |
| Name   |          | String    |        |
| Value  | 0        | String    |        |

Data ResultValue 
| Name  | Default  | DataType  | Notes  |
| Sum   |          | Integer   |        |

Data LabelValue 
| Name   | Default  | DataType  | Notes  |
| Label  |          | String    |        |
| Value  | 0        | Integer   |        |
```

In this version, the values for When and Then are passed as the single
element in a `List<List<String>`.   
You just obtain `values.get(0).get(0)` and use that.  It`s a good 
practice to include the domain term in the step, so that people will
know what it is. 

```
When filtered by Label with value
| a  |
Then sum is 
| 4 | 
```

## Strings

You can pass a multiline string to the glue code. If you include `ListOfString`, the glue code
will receive the string as a` List<String`>, instead of a `Strin`g.  

```
Scenario: Here are string options

* A multiline string to a string
  """
  One line
  Two line
  """

* A multiline string to a List of String # ListOfString
  """
  Three line
  Four line
  """
```

## Background and Cleanup

You can add a `Background `and a `Cleanup `to a feature file.   All steps in the `Background `will be run when the scenario starts.  All steps in the `Cleanup `will be run when the scenario ends.   `Background `and `Cleanup `use the same glue context as the scenario in which they run 

```
Feature: Background

Background:
Given Background function sets a value
| Background Here |

Cleanup::
Given value for cleanup should be set to
| Cleanup Here |

Scenario: Should have Background and Cleanup
Given a regular function
Then background should set value to
| Background Here |
And set a value for cleanup
| Cleanup Here |

Scenario: Should also have Background and Cleanup
Given a regular function
Then background should set value to
| Background Here |
And set a value for cleanup
| Cleanup Here |
```

## JSON

Four methods are added to the string version of the data class.   These methods convert an object to and from JSON and convert a table to and from JSON.   They were added since JSON is a popular way to represent attributes.   Methods to and from YAML or XML or some other format can be added.  

## Define

There is one more facet that might have
some use, depending on your context. With a `define`, you specify 
the value of a constant once, e.g.

```
 Define 
| Name       | Value | Notes                 |
| HIGH_VALUE | 100   | Highest allowed input |
| LOW_VALUE  | 1     | Lowest allowed input  |
```

Where ever you use these tokens, they will be replaced by the value.  For example:

```
Given this data:
| ID  | Value     |
| A   | HIGH_DATA |
| B   | LOW_DATA  |
```

will be treated as:

```
Given this data:
| ID  | Value     |
| 1   | 100       |
| B   | 1         |
```

This is useful if the Define terms are meaningful to someone reading 
the feature file. 

### Calculated Values

You can use an expression in the replacement, such as:

```
| Name           | Value | Notes               |
| AVERAGE_VALUE  | (LOW_DATA +HIGH_DATA)/2     | 
```

In this case, the computation will be passed, not the result of the computation:

```
Given this data:
| ID  | Value     |
| A   | HIGH_DATA |
| B   | LOW_DATA  |
| C   | AVERAGE_VALUE |
```

will be treated as:

```
Given this data:
| ID  | Value     |
| 1   | 100       |
| B   | 1         |
| C   | (1 + 100)/2 |
```

You need to create (or find somewhere) a class that computes the result
Of this calculation. Suppose it was called ComputeInt with a string constructor. The Data statement would have  Datatype ComputeInt for this
Field. 

For Java, you can check out the ScriptEngineManager and ScriptEngine classes from the `javax.script` package:


