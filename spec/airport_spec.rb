require 'airport'
require 'weather'

## Note these are just some guidelines!
## Feel free to write more tests!!

# A plane currently in the airport can be requested to take off.
#
# No more planes can be added to the airport, if it's full.
# It is up to you how many planes can land in the airport
# and how that is implemented.
#
# If the airport is full then no planes can land

describe Airport do

  describe 'take off' do

    it 'instructs a plane to take off' do
      expect(subject).to respond_to(:release)
    end

    it 'releases a plane' do
      subject.receive(Plane.new, (double :good_weather, stormy?: false) )
      plane = subject.release(double :good_weather, stormy?: false)
      expect(plane).to be_flying
    end

    it 'no longer contains the plane that was just released' do
      plane = Plane.new
      subject.receive(plane, (double :good_weather, stormy?: false) )
      subject.release(double :good_weather, stormy?: false)
      expect(subject.planes?).to_not include(plane)
    end

  end

  describe 'landing' do

    it 'instructs a plane to land' do
      expect(subject).to respond_to(:receive).with(2).argument
    end

    # it 'receives a plane' do
    #   expect(subject).to respond_to(:receive).with(1).argument
    # end

    it 'contains the plane it just received' do
      plane = Plane.new
      subject.receive(plane, (double :good_weather, stormy?: false) )
      expect(subject.planes?).to include(plane)
    end

  end

  describe 'traffic control' do

    context 'when the airport is empty' do

      it 'raises an error if a plane is requested for release' do
        expect{ subject.release(double :good_weather, stormy?: false) }.to raise_error 'No planes available.'
      end

    end

    context 'when airport is full' do

      it 'does not allow a plane to land' do
        Airport::CAPACITY.times { subject.receive(Plane.new, (double :good_weather, stormy?: false) ) }
        expect { subject.receive(Plane.new, (double :good_weather, stormy?: false) ) }.to raise_error 'The airport is full.'
      end

    end

    # Include a weather condition.
    # The weather must be random and only have two states "sunny" or "stormy".
    # Try and take off a plane, but if the weather is stormy,
    # the plane can not take off and must remain in the airport.
    #
    # This will require stubbing to stop the random return of the weather.
    # If the airport has a weather condition of stormy,
    # the plane can not land, and must not be in the airport

    context 'when weather conditions are stormy' do

      it 'does not allow a plane to take off' do
        subject.receive(Plane.new, (double :good_weather, stormy?: false) )
        expect { subject.release(double :good_weather, stormy?: true) }.to raise_error 'Plane cannot take off due to bad weather conditions.'
      end


      it 'does not allow a plane to land' do
        expect { subject.receive(Plane.new, (double :good_weather, stormy?: true) ) }.to raise_error 'Plane cannot land due to bad weather conditions.'
      end

    end

  end

end
