
require 'rails_helper'

describe Api::V1::ReservationsController, :type => :controller do
  service_response = 'some_service_response'

  let(:formatted_payload) { {} }
  let(:formatted_response) { { json: {} } }
  let(:params) { {} }
  let(:payload_instance) { double }
  let(:rendered_response) { double }
  let(:reservation) { { code: 'some_code' } }
  let(:reservations) { [ { code: 'some_code' }, { code: 'some_other_code' } ] }
  let(:response_instance) { double }

  before do
    allow(Reservations::PayloadFormatter).to receive(:new).and_return(payload_instance)
    allow(payload_instance).to receive(:to_h).and_return(formatted_payload)
    allow(Reservations::ResponseFormatter).to receive(:new).and_return(response_instance)
    allow(response_instance).to receive(:to_h).and_return(formatted_response)
    allow(Reservation).to receive_messages(
      all: reservations,
      find_by: reservation
    )
  end

  describe 'POST create' do
    subject do
      post :create, params: params
    end

    before do
      allow(CreateReservation).to receive(:run).and_return(service_response)
    end

    it 'runs the create service' do
      expect(Reservations::PayloadFormatter).to receive(:new).with(instance_of(ActionController::Parameters))
      expect(CreateReservation).to receive(:run).with(formatted_payload)
      expect(Reservations::ResponseFormatter).to receive(:new).with(service_response)

      subject
    end

    context 'when payload is invalid' do
      before do
        allow(payload_instance).to receive(:to_h).and_raise(InvalidPayloadFormatError)
      end

      it 'does not run the service' do
        expect(CreateReservation).to_not receive(:run)

        subject
      end
    end
  end

  describe 'GET index' do
    subject { get :index }

    it 'fetches reservations' do
      expect(Reservation).to receive(:all).with(no_args)

      subject
    end

    specify { expect(response).to have_http_status(200) }
  end
end
