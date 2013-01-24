class Riga

  attr_accessor :remote_id, :remote_appunto_id, :libro_id, :titolo, 
                :quantita, 
                :prezzo_unitario, :prezzo_copertina, :prezzo_consigliato,  
                :sconto, :importo, 
                :appunto

  def initialize(attributes = {})
    attributes.each_pair do |key, value|
      self.send("#{key}=", value) if self.respond_to?(key)
    end
  end

  def importo
    "%.2f" % (quantita.to_i * prezzo_unitario.to_f * (100 - sconto.to_f) / 100)
  end

end 