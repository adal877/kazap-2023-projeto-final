# frozen_string_literal: true

# Transaction types model
# The 'code' columns accepts only one of the following caracters: [P]ix, [T]ed and [W]ithdrawl
class TransactionsType < Sequel::Model
  plugin :validation_helpers

  self.raise_on_save_failure = true

  def validate
    validates_presence %i[code]
    validates_format /^(P|T|W)$/, :code
  end
end
