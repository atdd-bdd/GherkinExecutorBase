# Why Gherkin Executor?

#### Introduction

Cucumber has been around a long time and has great support. One feature that has been decreasing in ease of use are step tables (particularly in the Java version).   I had clients who preferred tables to data embedded in steps and I prefer them as well.  See [Six Shades of Gherkin | Ken Pugh&#039;s Blog](https://kenpugh.com/blog/six-shades-of-gherkin/)    I use a lot of scenarios that specify business rules.   Using a step table, rather than multiple steps with an example table, requires less glue code.     In addition, support for C++ has been difficult.  One had to use a wire protocol.   

#### The Idea

So what I was wanting was an easy way to create step definitions for step tables.  To be able to execute this required a new statement that specifies the data types for a table. The `Data`statement specifies the names, datatypes, and default values for attributes for a class. With that information, Gherkin Executor transforms step data tables into native language lists of objects of that class and calls the step function with those lists.    A developer only needs to add calls to the production code using those values.   

Each scenario is transformed into a native unit test (e.g. gtest for C++, pytest for Python, etc.).  So the tests run without interpretation.   Gherkin Executor creates two files - one that contains the unit tests with the data and one that contains the step glue code.  Only the step glue code is modified to call the production code.  

#### An Example

Here is a simple example to show how Gherkin Executor transforms a scenario with step tables. 

```
Scenario: Temperature Conversion
# Could use *  Calculation
Calculation Convert F to C # ListOfObject FandC
| F    | C    | Notes       |
| 32   | 0    | Freezing    |
| 212  | 100  | Boiling     |
| -40  | -40  | Below zero  |

Data FandC
| Name   | Default  | DataType  | Notes  |
| F      | 0        | Integer   |        |
| C      | 0        | Integer   |        |
| Notes  |          | String    |        |

```

The # ListOfObject FandC in the Calculation step links to the` Data FandC` statement.  A class called` FandC` with three string attributes will be created, along with a class called FandCInternal with two int and one sstring attributes.   These data types can be any user-defined class.   `

Gherkin Executor reads this file and creates a test file.  This example is for C++, other languages are similar.  `TEST_F` denotes a unit test in `gtest`.

```
class Feature_Examples : public ::testing::Test{
}
    TEST_F(Feature_Examples,Scenario_Temperature_Conversion) {
         Feature_Examples_glue feature_Examples_glue_object;

        std::vector<FandC> objectList1 = {
             FandC::Builder()
                .setF("32")
                .setC("0")
                .setNotes("Freezing")
                .build()
            // remainder of table initialized here 
            };
        feature_Examples_glue_object.Calculation_Convert_F_to_C(objectList1);
        }
```

The glue code file is also created.  The generated code includes a loop through the list.   The call to the production code has been added inside this loop.      

```
    void Feature_Examples_glue::Calculation_Convert_F_to_C(const std::vector<FandC>& values) {
            std::cout << "---  " << "Calculation_Convert_F_to_C" << std::endl; }
            for (const FandC& value : values) {
                std::cout << value.to_string() << std::endl;
                FandCInternal i = value.toFandCInternal();
                // Added calls to production code and asserts
                int result = gherkinexecutor::Production::convertFahrenheitToCelsius(i.f);
                ASSERT_EQ(i.c, result);
            }
        }
```

#### Issues and Tradeoffs

The glue code for each step resides in a single file.  It is not shareable with other feature files.   However, if code needed to be shared between two features, a shared function could be created and used by multiple glue codes.    

Since no data is embeded in the steps, steps may be be written differently, such as:   

```
# Instead of 
Given I have 1 cucumber 
# It could be 
Given I have cucumber quanity 
|1|
# or 
Given I have cucumbers 
| Quantity| 1 | 
# or 
Given I have 
| Item     | Quantity | 
| cucumber | 1        | 


```



Note that the domain term ("Quantity") is present in the table-only version 


