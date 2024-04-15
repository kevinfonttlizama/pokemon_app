class Pokemon < ApplicationRecord
  validates :nombre, :tipo, :imagen, presence: true
  enum estado_de_captura: { no_capturado: false, capturado: true }

  def self.import_first_150
    url = 'https://pokeapi.co/api/v2/pokemon?limit=150'
    pokemons_data = JSON.parse(Net::HTTP.get(URI(url)))
    pokemons_data['results'].each do |pokemon_entry|
      details = JSON.parse(Net::HTTP.get(URI(pokemon_entry['url'])))
      Pokemon.create(
        nombre: details['name'],
        tipo: details['types'].map { |type| type['type']['name'] }.join(', '),
        imagen: details['sprites']['front_default'],
        estado_de_captura: 'no_capturado'
      )
    end
  end
end
