module Domain
	module Orders

		class LineItem < Puree::Domain::Entity
			attr_identifier :product_code

			def initialize(product_code, price, quantity)
				@product_code = product_code
				@price = price
				@quantity = quantity
			end

			def change_quantity(quantity)
				signal_event :quantity_changed, old_quantity: @quantity, new_quantity: quantity
			end

			def total
				@quantity * @price
			end

			apply_event :quantity_changed do |args|
				@quantity = args[:new_quantity]
			end
		end

	end
end