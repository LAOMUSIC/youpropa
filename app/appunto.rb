class Appunto
  
  PROPERTIES = [:remote_id, :destinatario, :cliente_nome, :cliente_id, :note, :stato, :created_at, :telefono, :email]
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