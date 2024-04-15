require 'rails_helper'

RSpec.describe PokemonsController, type: :controller do
  describe "GET #index" do
    before do
      Pokemon.create(nombre: 'Bulbasaur', tipo: 'grass', imagen: 'url', estado_de_captura: 'no_capturado')
      get :index, params: { page: 1 }
    end

    it "returns a success response" do
      expect(response).to be_successful
      expect(response.body).to include('Bulbasaur')
      expect(response.body).to include('total_pages')
    end
  end
end
