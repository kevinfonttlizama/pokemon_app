# app/controllers/pokemons_controller.rb
class PokemonsController < ApplicationController
  before_action :set_pokemon, only: [:capture, :release]

  # GET /pokemons
  def index
    @pokemons = Pokemon.page(params[:page]).per(20)
    render json: @pokemons
  end

  # POST /pokemons/import
  def import
    url = "https://pokeapi.co/api/v2/pokemon?limit=150"
    response = HTTParty.get(url)
    if response.success?
      pokemons = response.parsed_response["results"]
      pokemons.each do |pokemon_data|
        detail_response = HTTParty.get(pokemon_data["url"])
        if detail_response.success?
          details = detail_response.parsed_response
          pokemon_type = details["types"].map { |type| type["type"]["name"] }.join(', ')
          pokemon_image = details["sprites"]["front_default"] || "https://example.com/default.png"
          Pokemon.find_or_create_by(nombre: details["name"]) do |pokemon|
            pokemon.tipo = pokemon_type
            pokemon.imagen = pokemon_image
            pokemon.estado_de_captura = 'no_capturado'
          end
        else
          puts "Failed to retrieve details for #{pokemon_data['name']}"
        end
      end
      head :ok
    else
      render json: { error: "Failed to connect to PokeAPI" }, status: :service_unavailable
    end
  end


  # POST /pokemons/:id/capture
  def capture
    @pokemon.update(captured: true)
    render json: @pokemon
  end

  # DELETE /pokemons/:id/release
  def release
    @pokemon.update(captured: false)
    render json: @pokemon
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end
end
