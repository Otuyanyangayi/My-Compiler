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
        when /\A[0-9]+/ then add_token(:NUMBER, $&)
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
      case @current_token[:type]
      when :ADD
        parse_binary_operation('+')
      when :SUB
        parse_binary_operation('-')
      when :MUL
        parse_binary_operation('*')
      when :DIV
        parse_binary_operation('/')
      when :MOD
        parse_binary_operation('%')
      when :POW
        parse_binary_operation('^')
      when :TERN
        parse_ternary_operation
      when :NUMBER
        value = @current_token[:value]
        consume(:NUMBER)
        return value
      else
        raise "Unexpected token: #{@current_token[:type]}"
      end
    end
  
    def parse_binary_operation(op)
      consume(@current_token[:type]) # Consume the operator (ADD, SUB, etc.)
      consume(:LPAREN)               # Expect an opening parenthesis after the operator
      left = parse_expression
      consume(:COMMA)                # Expect a comma between arguments
      right = parse_expression
      consume(:RPAREN)               # Expect a closing parenthesis after the arguments
      return "(#{left} #{op} #{right})"
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
      return "(#{cond} ? #{true_expr} : #{false_expr})"
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
  input = "add(5, mul(3, sub(10, pow(6, 4))))"
  compiler = Compiler.new(input)
  puts compiler.compile  # Outputs: "5 + 3 * (10 - 6 ^ 4)"
  