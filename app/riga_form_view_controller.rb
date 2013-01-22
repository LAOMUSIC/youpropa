class RigaFormViewController < UITableViewController
  
  extend IB

  outlet :editQuantita
  outlet :editPrezzo


  attr_accessor :libro, :riga

  def viewDidLoad
    true
  end

  def viewWillAppear(animated)
    super
    
    unless @riga 
      @riga = Riga.new
      puts "new riga"
    end
     
    # if @cliente
    #   @appunto.cliente_id = @cliente.remote_id
    #   @appunto.cliente_nome = @cliente.nome
    # end

    load_riga

  end

  def load_riga
    table = self.tableView
    
    (0..1).each do |index|
      
      cell = table.cellForRowAtIndexPath([0, index].nsindexpath)
      
      case index
        when 0
          cell.textLabel.text = @libro.titolo
        # when 1
        #   cell.detailTextLabel.text = @riga.destinatario
      end
    end  

    (0..5).each do |index|
      #path = NSIndexPath.indexPathForRow(0, inSection:1)
      cell = table.cellForRowAtIndexPath([1, index].nsindexpath)
      
      case index
        when 0
          cell.detailTextLabel.text = @libro.prezzo_copertina
        when 1
          cell.detailTextLabel.text = @libro.prezzo_consigliato
      end  
    end
  end
  
  
  def save(sender)

    if @riga.remote_id
      update_riga
    else
      create_riga
    end
  end

  def cancel(sender)
    if Device.ipad?
      self.dismissViewControllerAnimated(true, completion:nil)
    else
      self.navigationController.popViewControllerAnimated(true)
    end
  end

  private

    def create_riga
      puts "Creating new riga #{@riga.titolo}"
      App.delegate.backend.postObject(@riga, path:nil, parameters:nil,
                                 success: lambda do |operation, result|
                                                if Device.ipad?
                                                  self.dismissViewControllerAnimated(true, completion:nil)
                                                else
                                                  self.navigationController.popViewControllerAnimated(true)
                                                end
                                          end,
                                 failure: lambda do |operation, error|
                                                   App.alert error.localizedDescription
                                                 end)
    end

    def update_riga
      puts "Updating name for #{@riga.remote_id} to #{@riga.titolo}"
      App.delegate.backend.putObject(@riga, path:nil, parameters:nil,
                                success: lambda do |operation, result|
                                                  puts "updated"
                                                 if Device.ipad?
                                                    self.dismissViewControllerAnimated(true, completion:nil)
                                                  else
                                                    self.navigationController.popViewControllerAnimated(true)
                                                  end
                                                end,
                                failure: lambda do |operation, error|
                                                  App.alert error.localizedDescription
                                                end)
    end


end