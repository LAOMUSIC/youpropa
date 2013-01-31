class Appunto
  
  PROPERTIES = [:remote_id, :destinatario, :cliente_nome, :cliente_id, :note, :status, :created_at, :updated_at, :telefono, :email, :totale_copie, :totale_importo, :righe]
  
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

  def copie_righe
    righe.inject(0)  { |result, element| result + element.quantita.to_i }
  end

  def new_record?
    remote_id.blank?
  end
  
  def load_from_backend(&block)
    App.delegate.backend.getObject(self, path:nil, parameters:nil, 
                              success: lambda do |operation, result|
                                                puts result.firstObject.righe.count
                                                puts result.firstObject.righe.map(&:remote_id)
                                                puts self.righe.count
                                                puts self.righe.map(&:remote_id)
                                                block.call
                                              end,
                              failure: lambda do |operation, error|
                                                App.alert error.localizedDescription
                                                end)
  end
end