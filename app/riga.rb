class Riga

  attr_accessor :remote_id, :remote_appunto_id, :libro_id, :titolo, :quantita, :prezzo_unitario, :prezzo_copertina, :sconto

  def initialize(attributes = {})
    attributes.each_pair do |key, value|
      self.send("#{key}=", value) if self.respond_to?(key)
    end
  end

end 