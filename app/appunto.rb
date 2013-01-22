class Appunto
  
  PROPERTIES = [:remote_id, :destinatario, :cliente_nome, :cliente_id, :note, :status, :created_at, :telefono, :email, :totale_copie, :totale_importo, :righe]
  
  PROPERTIES.each { |prop|
    attr_accessor prop
  }
  
  def initialize(attributes = {})
    
    righe = []

    attributes.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end



  
end