
# My-Compiler 

## Author
[Grace Otuya]  
 

## Description
This project implements a compiler that parses and evaluates mathematical expressions defined by a simple function composition syntax. The compiler can handle basic arithmetic operations, including addition, subtraction, multiplication, division, power, modulo, and ternary operations.

## Implementation Details
- **Language**: Ruby
- **Libraries**: This project utilizes the built-in `minitest` library for testing purposes.
- **Structure**:
  - `compiler.rb`: Contains the implementation of the `Lexer`, `Parser`, and `Compiler` classes.
  - `test_compiler.rb`: Includes unit tests for verifying the functionality of the compiler.
- **Functionality**: The compiler takes input in the form of function calls (e.g., `add(2, 3)`) and converts them into mathematical expressions (e.g., `2 + 3`).
- **Not Implemented Parts / Known Bugs**: The current implementation does not support advanced mathematical functions such as trigonometric functions or logarithms. Known bugs include handling expressions without sufficient parentheses, which may lead to unexpected results.

## How to Run the Program
To run the compiler, ensure you have Ruby installed on your system. You can run the program using the following command:

```bash
ruby compiler.rb
