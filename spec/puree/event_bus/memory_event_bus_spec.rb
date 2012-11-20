require 'spec_helper'

describe 'A Memory Event Bus' do
	let(:event_bus) { Puree::EventBus::MemoryEventBus.new }

	context 'with Observers registered' do
		before(:each) do
			class TestObserver < Puree::EventBus::Observer
				def notifications
					@notifications ||= []
				end

				on_event :order_created do |args|
					notifications << args
				end

				on_event :item_added do |args|
					notifications << args
				end
			end

			@observer1 = TestObserver.new
			@observer2 = TestObserver.new

			event_bus.register(@observer1)
			event_bus.register(@observer2)
		end

		context 'when Events are published' do
			before(:each) do
				@event1 = Puree::Domain::Event.new('OrderFactory', :order_created,
					{ order_no: 123, name: 'my order' })
				@event2 = Puree::Domain::Event.new('Order_123', :item_added,
					{ order_no: 123, product_code: 'product1', price: 10.0, quantity: 2 })
				event_bus.publish(@event1)
				event_bus.publish(@event2)
			end

			it 'should notify all of the Observers' do
				@observer1.notifications.length.should == 2
				@observer1.notifications[0].should == @event1.args
				@observer1.notifications[1].should == @event2.args
				@observer2.notifications.length.should == 2
				@observer2.notifications[0].should == @event1.args
				@observer2.notifications[1].should == @event2.args
			end
		end
	end

	after(:all) do
		Object.send(:remove_const, :TestObserver)
	end
end