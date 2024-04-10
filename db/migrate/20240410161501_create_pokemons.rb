class CreatePokemons < ActiveRecord::Migration[7.1]
  def change
    create_table :pokemons do |t|
      t.string :nombre
      t.string :tipo
      t.string :imagen
      t.boolean :estado_de_captura

      t.timestamps
    end
  end
end
