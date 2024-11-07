require 'minitest/autorun'
require_relative 'compiler'

class TestCompiler < Minitest::Test
  def test_basic_addition
    input = "add(2, 3)"
    expected_output = "(2 + 3)"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for addition passed!"
  end

  def test_basic_subtraction
    input = "sub(7, 4)"
    expected_output = "(7 - 4)"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for subtraction passed!"
  end

  def test_basic_multiplication
    input = "mul(3, 5)"
    expected_output = "(3 * 5)"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for multiplication passed!"
  end

  def test_basic_division
    input = "div(10, 2)"
    expected_output = "(10 / 2)"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for division passed!"
  end

  def test_basic_modulo
    input = "mod(10, 3)"
    expected_output = "(10 % 3)"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for modulo passed!"
  end

  def test_basic_power
    input = "pow(6, 4)"
    expected_output = "(6 ^ 4)"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for power passed!"
  end

  def test_nested_operations
    input = "add(2, mul(3, sub(10, pow(6, 4))))"
    expected_output = "(2 + (3 * (10 - (6 ^ 4))))"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for nested operations passed!"
  end

  def test_ternary_operation
    input = "tern(add(1, 2), sub(3, 1), mul(2, 2))"
    expected_output = "((1 + 2) ? (3 - 1) : (2 * 2))"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for ternary operation passed!"
  end

  def test_complex_expression
    input = "add(1, mul(sub(5, 2), div(8, 4)))"
    expected_output = "(1 + ((5 - 2) * (8 / 4)))"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for complex expression passed!"
  end

  def test_multiple_operations
    input = "add(mul(3, 4), sub(10, div(20, 5)))"
    expected_output = "((3 * 4) + (10 - (20 / 5)))"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for multiple operations passed!"
  end

  def test_multiple_nested_operations
    input = "add(mul(2, 3), pow(2, 3))"
    expected_output = "((2 * 3) + (2 ^ 3))"
    assert_equal expected_output, Compiler.new(input).compile
    puts "Test for multiple nested operations passed!"
  end
end
