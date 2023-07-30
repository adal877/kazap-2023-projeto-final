# frozen_string_literal: true

# Transaction types model
# The 'code' columns accepts only one of the following caracters: [P]ix, [T]ed and [W]ithdrawl
class TransactionsType < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_presence %i[code]
    validates_format /^(P|T|W)$/, :code
  end
end
