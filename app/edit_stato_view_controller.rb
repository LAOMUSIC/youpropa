class EditStatoViewController < UITableViewController

  STATUS = ['da fare', 'in sospeso', 'completato']

  attr_accessor :statoChangedBlock, :appunto


  def tableView(tableView, numberOfRowsInSection:section)
    STATUS.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    unless cell = tableView.dequeueReusableCellWithIdentifier('statoCell')
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'statoCell')
    end
    stato = STATUS[indexPath.row]
    cell.textLabel.text = stato
    cell.accessoryType = UITableViewCellAccessoryCheckmark if stato == @appunto.stato
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)

    if @appunto.stato
      previousIndexPath = NSIndexPath.indexPathForRow(STATUS.index(@appunto.stato), inSection:0)
      cell = tableView.cellForRowAtIndexPath(previousIndexPath)
      cell.accessoryType = UITableViewCellAccessoryNone
    end
    
    tableView.cellForRowAtIndexPath(indexPath).accessoryType = UITableViewCellAccessoryCheckmark
    tableView.deselectRowAtIndexPath(indexPath, animated:true)

    text = @appunto.stato = STATUS[indexPath.row]

    error = Pointer.new(:object)
    success = @statoChangedBlock.call(text, error)
    if (success) 
      self.navigationController.popViewControllerAnimated(true)
      return true
    else
      alertView = UIAlertView.alloc.initWithTitle("Error", message:error.localizedDescription, delegate:nil, cancelButtonTitle:"Chiudi", otherButtonTitles:nil);
      alertView.show
      return false
    end

  end

  def close(sender)
    self.navigationController.popViewControllerAnimated(true)
  end
end