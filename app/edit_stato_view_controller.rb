class EditStatoViewController < UITableViewController

  STATUSES = ['da fare', 'in sospeso', 'completato']

  attr_accessor :statoChangedBlock, :appunto


  def tableView(tableView, numberOfRowsInSection:section)
    STATUSES.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    unless cell = tableView.dequeueReusableCellWithIdentifier('statoCell')
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'statoCell')
    end
    status = STATUSES[indexPath.row]
    cell.textLabel.text = status
    cell.accessoryType = UITableViewCellAccessoryCheckmark if status == @appunto.status.split("_").join(" ")
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)

    if @appunto.status
      previousIndexPath = NSIndexPath.indexPathForRow(STATUSES.index(@appunto.status.split("_").join(" ")), inSection:0)
      cell = tableView.cellForRowAtIndexPath(previousIndexPath)
      cell.accessoryType = UITableViewCellAccessoryNone
    end
    
    tableView.cellForRowAtIndexPath(indexPath).accessoryType = UITableViewCellAccessoryCheckmark
    tableView.deselectRowAtIndexPath(indexPath, animated:true)

    text = @appunto.status = STATUSES[indexPath.row].split(" ").join("_")

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