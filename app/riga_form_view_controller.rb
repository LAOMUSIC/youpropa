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
      @riga = Riga.new(quantita: 1, prezzo_unitario: @libro.prezzo_consigliato)
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
        when 1
          cell.detailTextLabel.text = "€ %.2f" % @libro.prezzo_copertina
      end
    end  

    (0..5).each do |index|
      #path = NSIndexPath.indexPathForRow(0, inSection:1)
      cell = table.cellForRowAtIndexPath([1, index].nsindexpath)
      
      case index
        when 0
          cell.detailTextLabel.text = @riga.quantita.to_s
        when 1
          cell.detailTextLabel.text = "€ %.2f" % @riga.prezzo_unitario
      end  
    end
  end
  
  def prepareForEditQuantitaSegue(segue, sender:sender)
    editController = segue.destinationViewController
    editController.testo = @riga.quantita.to_s
    editController.setTextChangedBlock( lambda do |text, error|
        cell = self.tableView.cellForRowAtIndexPath([1, 0].nsindexpath)
        cell.detailTextLabel.setText(text)
        @riga.quantita = text.to_i
        return true
      end
    )
  end

  def prepareForSelectPrezzoSegue(segue, sender:sender)
    editController = segue.destinationViewController
    editController.riga  = @riga
    editController.libro = @libro
    editController.setStatoChangedBlock( lambda do |text, error|
        cell = self.tableView.cellForRowAtIndexPath([1, 1].nsindexpath)

        puts text
        cell.detailTextLabel.text = text

        formatter = NSNumberFormatter.alloc.init
        formatter.setNumberStyle NSNumberFormatterDecimalStyle
        formatter.setMaximumFractionDigits 2
        formatter.setRoundingMode NSNumberFormatterRoundHalfUp

        number = formatter.stringFromNumber(Value)



        @riga.prezzo_unitario = text.split(" ")[1].to_f.round(2)
        puts @riga.prezzo_unitario
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