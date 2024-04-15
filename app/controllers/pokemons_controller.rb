# app/controllers/pokemons_controller.rb
class PokemonsController < ApplicationController
  before_action :set_pokemon, only: [:capture, :destroy]
  
  def index
    pokemons = Pokemon.all
    render json: pokemons.as_json(only: [:id, :nombre, :tipo, :imagen, :estado_de_captura])
  end
  

  def capture
    if Pokemon.where(estado_de_captura: true).count >= 6
      oldest = Pokemon.where(estado_de_captura: true).order(:updated_at).first
      oldest.update(estado_de_captura: false)
    end
    @pokemon.update(estado_de_captura: true)
    render json: @pokemon
  end

  def destroy
    @pokemon.update(estado_de_captura: false)
    render json: @pokemon
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end
end
