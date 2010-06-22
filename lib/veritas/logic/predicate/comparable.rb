module Veritas
  module Logic
    class Predicate
      module Comparable
        def self.included(descendant)
          descendant.extend ClassMethods
        end

        def complement
          self.class.complement.new(left, right)
        end

        def inspect
          "#{left.inspect} #{self.class.operation} #{right.inspect}"
        end

      private

        def swap
          self.class.new(right, left)
        end

        def always_equivalent?
          left_attribute? && right_attribute? && same_attributes?
        end

        def never_equivalent?
          left  = self.left
          right = self.right

          if    right_constant? then !left.valid_value?(right)
          elsif left_constant?  then !right.valid_value?(left)
          else
            !joinable?
          end
        end

        module ClassMethods
          def eval(left, right)
            left.send(operation, right)
          end

        end # module Classmethods
      end # module Comparable
    end # class Predicate
  end # module Logic
end # module Veritas