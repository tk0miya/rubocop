# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::MultilineMethodSignature, :config do
  context 'when arguments span a single line' do
    context 'when defining an instance method' do
      it 'registers an offense when closing paren is on the following line' do
        expect_offense(<<~RUBY)
          def foo(bar
          ^^^^^^^^^^^ Avoid multi-line method signatures.
              )
          end
        RUBY
      end

      context 'when method signature is on a single line' do
        it 'does not register an offense for parameterized method' do
          expect_no_offenses(<<~RUBY)
            def foo(bar, baz)
            end
          RUBY
        end

        it 'does not register an offense for unparameterized method' do
          expect_no_offenses(<<~RUBY)
            def foo
            end
          RUBY
        end
      end
    end

    context 'when defining an class method' do
      context 'when arguments span a single line' do
        it 'registers an offense when closing paren is on the following line' do
          expect_offense(<<~RUBY)
            def self.foo(bar
            ^^^^^^^^^^^^^^^^ Avoid multi-line method signatures.
                )
            end
          RUBY
        end
      end

      context 'when method signature is on a single line' do
        it 'does not register an offense for parameterized method' do
          expect_no_offenses(<<~RUBY)
            def self.foo(bar, baz)
            end
          RUBY
        end

        it 'does not register an offense for unparameterized method' do
          expect_no_offenses(<<~RUBY)
            def self.foo
            end
          RUBY
        end
      end
    end
  end

  context 'when arguments span multiple lines' do
    context 'when defining an instance method' do
      it 'registers an offense when `end` is on the following line' do
        expect_offense(<<~RUBY)
          def foo(bar,
          ^^^^^^^^^^^^ Avoid multi-line method signatures.
                  baz)
          end
        RUBY
      end

      it 'registers an offense when `end` is on the same line' do
        expect_offense(<<~RUBY)
          def foo(bar,
          ^^^^^^^^^^^^ Avoid multi-line method signatures.
                  baz); end
        RUBY
      end
    end

    context 'when defining an class method' do
      it 'registers an offense when `end` is on the following line' do
        expect_offense(<<~RUBY)
          def self.foo(bar,
          ^^^^^^^^^^^^^^^^^ Avoid multi-line method signatures.
                  baz)
          end
        RUBY
      end

      it 'registers an offense when `end` is on the same line' do
        expect_offense(<<~RUBY)
          def self.foo(bar,
          ^^^^^^^^^^^^^^^^^ Avoid multi-line method signatures.
                  baz); end
        RUBY
      end
    end

    context 'when correction would exceed maximum line length' do
      let(:other_cops) do
        {
          'Layout/LineLength' => { 'Max' => 5 }
        }
      end

      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          def foo(bar,
                  baz)
          end
        RUBY
      end
    end

    context 'when correction would not exceed maximum line length' do
      let(:other_cops) do
        {
          'Layout/LineLength' => { 'Max' => 25 }
        }
      end

      it 'registers an offense' do
        expect_offense(<<~RUBY)
          def foo(bar,
          ^^^^^^^^^^^^ Avoid multi-line method signatures.
                  baz)
            qux.qux
          end
        RUBY
      end
    end
  end
end
