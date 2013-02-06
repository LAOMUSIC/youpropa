class Classe
  
  PROPERTIES = [:remote_id, :classe, :sezione, :nr_alunni, :remote_cliente_id]
  
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