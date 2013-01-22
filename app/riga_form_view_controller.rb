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
      @riga = Riga.new(quantita: 1)
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
      end
    end  

    (0..5).each do |index|
      #path = NSIndexPath.indexPathForRow(0, inSection:1)
      cell = table.cellForRowAtIndexPath([1, index].nsindexpath)
      
      case index
        when 0
          cell.detailTextLabel.text = @riga.quantita.to_s
        when 1
          cell.detailTextLabel.text = @libro.prezzo_consigliato
      end  
    end
  end
  
  def prepareForEditQuantitaSegue(segue, sender:sender)
    editController = segue.destinationViewController
    editController.testo = @riga.quantita
    editController.setTextChangedBlock( lambda do |text, error|
        path = NSIndexPath.indexPathForRow(1, inSection:0)
        cell = self.tableView.cellForRowAtIndexPath(path)
        cell.detailTextLabel.setText(text)
        @riga.quantita = text
        return true
      end
    )
  end

  def prepareForSelectPrezzoSegue(segue, sender:sender)
    editController = segue.destinationViewController
    editController.appunto = @appunto
    #editController.textView.setText(name)
    editController.setStatoChangedBlock( lambda do |text, error|
        path = NSIndexPath.indexPathForRow(3, inSection:0)
        cell = self.tableView.cellForRowAtIndexPath(path)
        cell.detailTextLabel.setText(text)
        @appunto.status = text
        return true
      end
    )
  end

  def prepareForSegue(segue, sender:sender)
    if segue.identifier.isEqualToString("editQuantita") 
      self.prepareForEditQuantitaSegue(segue, sender:sender)
    elsif segue.identifier.isEqualToString("selectPrezzo") 
      self.prepareForSelectPrezzoSegue(segue, sender:sender)
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