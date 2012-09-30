module Puree
	module Persistence

		class MemoryEventStore

			def initialize
				@events = []
			end

			def save(event)
				@events << event
			end

			def get_by_aggregate_root_id(aggregate_root_id)
				@events.find_all do |event|
					event.aggregate_root_id == aggregate_root_id
				end
			end

			def reset
				@events.clear
			end
			
		end

	end
end