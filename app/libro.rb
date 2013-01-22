class Libro

  PROPERTIES = [:remote_id, :titolo, :sigla, :prezzo_copertina, :prezzo_consigliato, :settore]
  
  PROPERTIES.each { |prop|
    attr_accessor prop
  }
  
  def initialize(attributes = {})
    attributes.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end

end