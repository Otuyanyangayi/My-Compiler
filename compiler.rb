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
        when /\A-?(0|[1-9]\d*)(\.\d+)?(e[+-]?\d+)?/i then add_token(:NUMBER, $&) # Number parsing
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
    PRECEDENCE = {
      '+' => 1, '-' => 1,
      '*' => 2, '/' => 2, '%' => 2,
      '^' => 3
    }
  
    def initialize(tokens)
      @tokens = tokens
      @current_token = @tokens.shift
    end
  
    def parse_expression(precedence = 0)
      left = parse_primary
  
      while @current_token && precedence < get_precedence
        operator = @current_token[:value]
        consume(@current_token[:type])  # Consume the operator
  
        right_precedence = operator == '^' ? PRECEDENCE[operator] : precedence
        right = parse_expression(right_precedence)
  
        # Handle output formatting for exponentiation
        if operator == '^'
          left = "(#{left} ^ #{right})"  # Add parentheses for exponentiation
        else
          left = "#{left} #{operator} #{right}"
        end
      end
  
      left
    end
  
    def parse_primary
      case @current_token[:type]
      when :NUMBER
        value = @current_token[:value]
        consume(:NUMBER)
        return value
      when :LPAREN
        consume(:LPAREN)
        expr = parse_expression
        consume(:RPAREN)
        return "(#{expr})"
      when :ADD
        consume(:ADD)
        consume(:LPAREN)
        left = parse_expression
        consume(:COMMA)
        right = parse_expression
        consume(:RPAREN)
        return "#{left} + #{right}"
      when :SUB
        consume(:SUB)
        consume(:LPAREN)
        left = parse_expression
        consume(:COMMA)
        right = parse_expression
        consume(:RPAREN)
        return "#{left} - #{right}"
      when :MUL
        consume(:MUL)
        consume(:LPAREN)
        left = parse_expression
        consume(:COMMA)
        right = parse_expression
        consume(:RPAREN)
        return "#{left} * #{right}"
      when :DIV
        consume(:DIV)
        consume(:LPAREN)
        left = parse_expression
        consume(:COMMA)
        right = parse_expression
        consume(:RPAREN)
        return "#{left} / #{right}"
      when :MOD
        consume(:MOD)
        consume(:LPAREN)
        left = parse_expression
        consume(:COMMA)
        right = parse_expression
        consume(:RPAREN)
        return "#{left} % #{right}"
      when :POW
        consume(:POW)
        consume(:LPAREN)
        left = parse_expression
        consume(:COMMA)
        right = parse_expression
        consume(:RPAREN)
        return "(#{left} ^ #{right})"
      when :TERN
        consume(:TERN)
        consume(:LPAREN)
        cond = parse_expression
        consume(:COMMA)
        true_expr = parse_expression
        consume(:COMMA)
        false_expr = parse_expression
        consume(:RPAREN)
        return "(#{cond} ? #{true_expr} : #{false_expr})"
      else
        raise "Unexpected token: #{@current_token[:type]}"
      end
    end
  
    def get_precedence
      return 0 unless @current_token
      PRECEDENCE[@current_token[:value]] || 0
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
  input = "tern(5e2, 2.7, 1)"  # Testing input with a ternary operation
  compiler = Compiler.new(input)
  puts compiler.compile  # Outputs: "(5e2 ? 2.7 : 1)"
  