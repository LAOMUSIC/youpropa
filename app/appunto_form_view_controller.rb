class AppuntoFormViewController < UITableViewController

  attr_accessor :appunto, :cliente

  def viewDidLoad
    true
  end

  def viewWillAppear(animated)
    super
    
    unless @appunto 
      @appunto = Appunto.new(status: "da fare", righe: [])
    end
    if @cliente
      @appunto.cliente_id = @cliente.remote_id
      @appunto.cliente_nome = @cliente.nome
    end
    load_appunto
  end

  def load_appunto
    table = self.tableView
    
    (0..3).each do |index|
      
      path = NSIndexPath.indexPathForRow(index, inSection:0)
      cell = table.cellForRowAtIndexPath(path)
      
      case index
        when 0
          cell.detailTextLabel.text = @appunto.cliente_nome
        when 1
          cell.detailTextLabel.text = @appunto.destinatario
        when 2
          temp = cell.viewWithTag(1123)
          temp.setText(@appunto.note)
        when 3
          cell.detailTextLabel.text = @appunto.status.split("_").join(" ")
      end

      #path = NSIndexPath.indexPathForRow(0, inSection:1)
      cell = table.cellForRowAtIndexPath([1, 0].nsindexpath)
      
      if @appunto.righe.empty?
        cell.textLabel.text = "Aggiungi volumi"
        cell.detailTextLabel.text = ""
      else
        cell.textLabel.text = "Totale volumi"
        cell.detailTextLabel.text = @appunto.totale_copie.to_s
      end

    end
  end
  
  def prepareForEditDestinatarioSegue(segue, sender:sender)
    editController = segue.destinationViewController
    editController.testo = @appunto.destinatario
    #editController.textField.setText(name)
    editController.setTextChangedBlock( lambda do |text, error|
        path = NSIndexPath.indexPathForRow(1, inSection:0)
        cell = self.tableView.cellForRowAtIndexPath(path)
        cell.detailTextLabel.setText(text)
        @appunto.destinatario = text
        return true
      end
    )
  end
 
  def prepareForEditNoteSegue(segue, sender:sender)
    editController = segue.destinationViewController
    editController.testo = @appunto.note
    #editController.textView.setText(name)
    editController.setTextChangedBlock( lambda do |text, error|
        path = NSIndexPath.indexPathForRow(2, inSection:0)
        cell = self.tableView.cellForRowAtIndexPath(path)
        temp = cell.viewWithTag(1123)
        temp.setText(text)
        @appunto.note = text
        return true
      end
    )
  end

  def prepareForEditStatoSegue(segue, sender:sender)
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

  def prepareForSelectRigheSegue(segue, sender:sender)
    editController = segue.destinationViewController
    editController.appunto = @appunto
  end

  def prepareForSegue(segue, sender:sender)
    if segue.identifier.isEqualToString("editDestinatario") 
      self.prepareForEditDestinatarioSegue(segue, sender:sender)
    elsif segue.identifier.isEqualToString("editNote") 
      self.prepareForEditNoteSegue(segue, sender:sender)
    elsif segue.identifier.isEqualToString("editStato") 
      self.prepareForEditStatoSegue(segue, sender:sender)
    elsif segue.identifier.isEqualToString("selectRighe") 
      self.prepareForSelectRigheSegue(segue, sender:sender)
    end
  end

  def save(sender)
    @appunto.status = @appunto.status.split(" ").join("_")
    if @appunto.remote_id
      update_appunto
    else
      create_appunto
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

    def create_appunto
      puts "Creating new appunto #{@appunto.cliente_nome}"
      App.delegate.backend.postObject(@appunto, path:nil, parameters:nil,
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

    def update_appunto
      puts "Updating name for #{@appunto.remote_id} to #{@appunto.cliente_nome}"
      App.delegate.backend.putObject(@appunto, path:nil, parameters:nil,
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