class Cliente
  
  attr_accessor :remote_id, :nome, :comune, :frazione, :cliente_tipo, :indirizzo, :cap, :provincia, 
                :telefono, :email, :latitude, :longitude, :appunti, :classi, :docenti

  def initialize(attributes = {})
    appunti = []
    classi  = []
    docenti = []
    
    attributes.each_pair do |key, value|
      self.send("#{key}=", value) if self.respond_to?(key)
    end
  end

  def citta
    self.frazione.blank? ? self.comune : self.frazione
  end
  
end