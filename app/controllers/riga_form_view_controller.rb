class RigaFormViewController < UITableViewController
  
  extend IB

  outlet :editQuantita
  outlet :editPrezzo


  attr_accessor :riga, :appunto

  def viewDidLoad
    true
  end

  def viewWillAppear(animated)
    super
    load_riga
  end

  def load_riga
    table = self.tableView
    
    (0..1).each do |index|
      cell = table.cellForRowAtIndexPath([0, index].nsindexpath)
      case index
        when 0
          cell.textLabel.text = @riga.titolo
        when 1
          cell.detailTextLabel.text = "€ %.2f" % @riga.prezzo_copertina
      end
    end  

    (0..2).each do |index|
      cell = table.cellForRowAtIndexPath([1, index].nsindexpath)
      case index
        when 0
          cell.detailTextLabel.text = @riga.quantita.to_s
        when 1
          cell.detailTextLabel.text = "€ %.2f" % @riga.prezzo_unitario
        when 2
          cell.detailTextLabel.text = @riga.sconto.to_s
      end  
    end

    cell = table.cellForRowAtIndexPath([2, 0].nsindexpath)
    cell.detailTextLabel.text = @riga.importo.to_s

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
    puts @riga
    editController.setPrezzoChangedBlock( lambda do |prezzo, sconto, error|
        # prezzo_cell = self.tableView.cellForRowAtIndexPath([1, 1].nsindexpath)
        # prezzo_cell.detailTextLabel.text = prezzo.to_s
        # sconto_cell = self.tableView.cellForRowAtIndexPath([1, 2].nsindexpath)
        # sconto_cell.detailTextLabel.text = sconto.to_s
        @riga.prezzo_unitario = prezzo
        @riga.sconto = sconto
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
      puts "Creating new riga #{@riga.titolo} #{@riga.libro_id}"
      App.delegate.backend.postObject(@riga, path:nil, parameters:nil,
                                 success: lambda do |operation, result|
                                                @appunto.righe << result.firstObject
                                                if Device.ipad?
                                                  self.navigationController.popViewControllerAnimated(true)
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
                                                  if Device.ipad?
                                                    self.navigationController.popViewControllerAnimated(true)
                                                  else
                                                    self.navigationController.popViewControllerAnimated(true)
                                                  end
                                                end,
                                failure: lambda do |operation, error|
                                                  App.alert error.localizedDescription
                                                end)
    end


end