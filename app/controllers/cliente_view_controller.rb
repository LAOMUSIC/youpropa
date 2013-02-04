class ClienteViewController < UIViewController
  extend IB

  attr_accessor :remote_cliente_id
  outlet :name_text_field

  def viewDidLoad
    @cliente = Cliente.new
    load_cliente if remote_cliente_id
    true
  end



  # def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
  #   true
  # end

  # def viewWillAppear(animated)
  #   #load_cliente if remote_cliente_id
  # end

  def textFieldShouldReturn(field)
    field.resignFirstResponder
  end

  def save_button_pressed(sender)
    
    puts @cliente

    #@cliente.nome = name_text_field.text
    # if @cliente.remote_id
    #   update_cliente
    # else
    #   create_cliente
    # end
  end

  # def delete_button_pressed(sender)
  #   if @cliente.remote_id
  #     delete_cliente
  #   else
  #     App.alert("No cliente to delete, silly.")
  #   end
  # end

  private

  def load_cliente
    @cliente = Cliente.new(remote_id: remote_cliente_id)
    App.delegate.backend.getObject(@cliente, path:nil, parameters:nil, 
                              success: lambda do |operation, result|
                                                cliente_nome = result.firstObject.nome
                                                name_text_field.text = cliente_nome
                                              end,
                              failure: lambda do |operation, error|
                                                App.delegate.alert error.localizedDescription
                                              end)
  end

  def create_cliente
    puts "Creating new cliente #{@cliente.nome}"
    App.delegate.backend.postObject(@cliente, path:nil, parameters:nil,
                               success: lambda do |operation, result|
                                          self.navigationController.popViewControllerAnimated true 
                                        end,
                               failure: lambda do |operation, error|
                                                 App.alert error.localizedDescription
                                               end)
  end

  def update_cliente
    puts "Updating name for #{@cliente.remote_id} to #{@cliente.nome}"
    App.delegate.backend.putObject(@cliente, path:nil, parameters:nil,
                              success: lambda do |operation, result|
                                                puts "updated"
                                                self.navigationController.popViewControllerAnimated true
                                              end,
                              failure: lambda do |operation, error|
                                                App.alert error.localizedDescription
                                              end)
  end

  def delete_cliente
    puts "Deleting cliente #{@cliente.remote_id}"
    App.delegate.backend.deleteObject(@cliente, path:nil, parameters:nil,
                              success: lambda do |operation, result|
                                          self.navigationController.popViewControllerAnimated true    
                                       end,
                              failure: lambda do |operation, error|
                                                App.alert error.localizedDescription
                                              end)
  end
end
