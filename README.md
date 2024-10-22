
**Ruby Function Composition Compiler**

**Author:Grace Otuya** 

This project is a simple compiler written in Ruby that parses a composition of mathematical functions and transforms them into equivalent mathematical expressions.

**Overview**

The compiler takes an input string containing function compositions (like `add`, `sub`, `mul`, etc.) and converts them into standard mathematical expressions by applying the appropriate operator precedence and eliminating unnecessary parentheses.

**Example**

Given the input:

```
add(5, mul(3, sub(10, pow(6, 4))))
```

The compiler will output:

```
5 + 3 * (10 - 6 ^ 4)
```

**Supported Functions**

The following functions are supported:

- `add(x, y)` - Addition (x + y)
- `sub(x, y)` - Subtraction (x - y)
- `mul(x, y)` - Multiplication (x * y)
- `div(x, y)` - Division (x / y)
- `mod(x, y)` - Modulo (x % y)
- `pow(x, y)` - Power (x ^ y)
- `tern(x, y, z)` - Ternary operator (x ? y : z)

**Operator Precedence**

The operators follow standard precedence rules:

- Ternary (? :)
- Addition/Subtraction (+, -)
- Multiplication/Division/Modulo (*, /, %)
- Power (^)

**Left and Right Associativity**

- The `^` operator and `? :` ternary operator are right-associative.
- All other operators are left-associative.

**Getting Started**

**Prerequisites**

- You need to have Ruby installed on your system. You can check the installation by running:

```bash
ruby --version
```

**Running the Compiler**

1. Clone or download this repository.
2. Save the provided Ruby code into a file named `compiler.rb`.
3. Run the compiler using:

```bash
ruby compiler.rb
```

**Example Usage**

In `compiler.rb`, you can change the input function composition by modifying the `input` variable. For example:

```ruby
input = "add(5, mul(3, sub(10, pow(6, 4))))"
```

Then run the script to see the output:

```bash
5 + 3 * (10 - 6 ^ 4)
```

**Project Structure**

- `Lexer` class: Responsible for breaking down the input string into tokens (lexical analysis).
- `Parser` class: Responsible for parsing the tokens and generating a mathematical expression based on the function composition (syntax analysis).
- `Compiler` class: Combines the lexer and parser to compile the input function composition into its equivalent mathematical expression.

**Error Handling**

If the input contains an unknown function or invalid syntax, the compiler will raise an error and output the error message in the console.

**Contributing**

Feel free to fork this repository, submit pull requests, or open issues if you find bugs or have suggestions for improvements.

**License**

This project is open-source and is licensed under the MIT License.
