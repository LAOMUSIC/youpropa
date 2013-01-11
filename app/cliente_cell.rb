class ClienteCell < UITableViewCell
  
  attr_reader :cliente
  
  def cliente=(cliente)
    @cliente = cliente
    textLabel.text = @cliente.nome
    detailTextLabel.text = @cliente.citta
  end

end
