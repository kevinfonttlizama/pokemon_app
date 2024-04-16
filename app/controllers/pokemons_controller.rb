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

  def capture
    if @pokemon.update(estado_de_captura: 'capturado')
      render json: @pokemon
    else
      render json: @pokemon.errors, status: :unprocessable_entity
    end
  end

  def release
    if @pokemon.update(estado_de_captura: 'no_capturado')
      render json: @pokemon
    else
      render json: @pokemon.errors, status: :unprocessable_entity
    end
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end




  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end
end
