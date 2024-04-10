# app/controllers/pokemon_controller.rb

class PokemonController < ApplicationController
  def index
    pokemons = Pokemon.all.page(params[:page]).per(10) # Lista pokemones según página
    pokemons = pokemons.where("nombre LIKE ? OR tipo LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present? # Filtro según nombre o tipo
    total_pokemons = Pokemon.count
    total_pages = (total_pokemons / 10.0).ceil
    render json: { pokemons: pokemons, total_pokemons: total_pokemons, total_pages: total_pages }
  end

  def capture
    captured_pokemons_count = Pokemon.where(estado_de_captura: true).count
    if captured_pokemons_count >= 6
      oldest_pokemon = Pokemon.where(estado_de_captura: true).order(created_at: :asc).first
      oldest_pokemon.update(estado_de_captura: false)
    end
    pokemon = Pokemon.find(params[:id])
    pokemon.update(estado_de_captura: true)
    render json: pokemon
  end

  def captured
    captured_pokemons = Pokemon.where(estado_de_captura: true)
    render json: captured_pokemons
  end

  def destroy
    pokemon = Pokemon.find(params[:id])
    pokemon.update(estado_de_captura: false)
    render json: pokemon
  end

  def import
    url = 'https://pokeapi.co/api/v2/pokemon/?limit=150' # URL de la API de Pokémon para obtener los primeros 150 Pokémon
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    data['results'].each do |pokemon_data|
      pokemon_url = pokemon_data['url']
      pokemon_uri = URI(pokemon_url)
      pokemon_response = Net::HTTP.get(pokemon_uri)
      pokemon_details = JSON.parse(pokemon_response)

      Pokemon.create(
        nombre: pokemon_details['name'],
        tipo: pokemon_details['types'][0]['type']['name'], # Supongamos que tomamos solo el primer tipo del Pokémon
        imagen: pokemon_details['sprites']['front_default'],
        estado_de_captura: false # Por defecto, no capturado
      )
    end

    render json: { message: 'Importación exitosa de los primeros 150 Pokémon.' }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
