class Lexer
  def initialize(input)
    @input = input.gsub(/\s+/, '')  # Remove all whitespace
    @tokens = []
    tokenize
  end

  def tokenize
    until @input.empty?
      case @input
      when /\Aadd/ then add_token(:ADD, 'add')
      when /\Asub/ then add_token(:SUB, 'sub')
      when /\Amul/ then add_token(:MUL, 'mul')
      when /\Adiv/ then add_token(:DIV, 'div')
      when /\Amod/ then add_token(:MOD, 'mod')
      when /\Apow/ then add_token(:POW, 'pow')
      when /\Atern/ then add_token(:TERN, 'tern')
      when /\A[0-9]+(?:\.[0-9]+)?(?:e-?\d+)?/ then add_token(:NUMBER, $&)
      when /\A\(/ then add_token(:LPAREN, '(')
      when /\A\)/ then add_token(:RPAREN, ')')
      when /\A,/ then add_token(:COMMA, ',')
      else
        raise "Unknown token: #{@input}"
      end
    end
  end

  def add_token(type, value)
    @tokens << { type: type, value: value }
    @input = @input[value.length..-1]
  end

  def tokens
    @tokens
  end
end

class Parser
  def initialize(tokens)
    @tokens = tokens
    @current_token = @tokens.shift
  end

  def parse_expression
    if @current_token[:type] == :TERN
      parse_ternary_operation
    else
      parse_term
    end
  end

  def parse_term
    left = parse_factor

    while @current_token && [:ADD, :SUB].include?(@current_token[:type])
      op = @current_token[:type] == :ADD ? '+' : '-'
      consume(@current_token[:type])
      right = parse_factor
      left = "(#{left} #{op} #{right})"
    end

    left
  end

  def parse_factor
    left = parse_power

    while @current_token && [:MUL, :DIV, :MOD].include?(@current_token[:type])
      op = case @current_token[:type]
           when :MUL then '*'
           when :DIV then '/'
           when :MOD then '%'
           end
      consume(@current_token[:type])
      right = parse_power
      left = "(#{left} #{op} #{right})"
    end

    left
  end

  def parse_power
    left = parse_primary

    while @current_token && @current_token[:type] == :POW
      consume(:POW)
      right = parse_primary
      left = "(#{left} ^ #{right})"
    end

    left
  end

  def parse_primary
    case @current_token[:type]
    when :NUMBER
      value = @current_token[:value]
      consume(:NUMBER)
      value
    when :LPAREN
      consume(:LPAREN)
      expr = parse_expression
      consume(:RPAREN)
      expr
    when :ADD, :SUB, :MUL, :DIV, :MOD, :POW
      parse_binary_operation
    else
      raise "Unexpected token: #{@current_token[:type]}"
    end
  end

  def parse_binary_operation
    op_token = @current_token[:type]
    consume(op_token) # Consume the operator (ADD, SUB, etc.)
    consume(:LPAREN)  # Expect an opening parenthesis after the operator
    left = parse_expression
    consume(:COMMA)   # Expect a comma between arguments
    right = parse_expression
    consume(:RPAREN)  # Expect a closing parenthesis after the arguments

    operator = case op_token
               when :ADD then '+'
               when :SUB then '-'
               when :MUL then '*'
               when :DIV then '/'
               when :MOD then '%'
               when :POW then '^'
               end
    "(#{left} #{operator} #{right})"
  end

  def parse_ternary_operation
    consume(:TERN)
    consume(:LPAREN)
    cond = parse_expression
    consume(:COMMA)
    true_expr = parse_expression
    consume(:COMMA)
    false_expr = parse_expression
    consume(:RPAREN)
    "((#{cond}) ? (#{true_expr}) : (#{false_expr}))"
  end

  def consume(expected_type)
    if @current_token[:type] == expected_type
      @current_token = @tokens.shift
    else
      raise "Expected #{expected_type}, got #{@current_token[:type]}"
    end
  end
end

class Compiler
  def initialize(input)
    @lexer = Lexer.new(input)
    @parser = Parser.new(@lexer.tokens)
  end

  def compile
    @parser.parse_expression
  end
end

# Example usage
input = "add(2, 3)"
compiler = Compiler.new(input)
puts compiler.compile  # Expected output: "(5 + (3 * (10 - (6 ^ 4))))"
