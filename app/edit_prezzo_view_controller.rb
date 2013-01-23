class EditPrezzoViewController < UITableViewController

  attr_accessor :statoChangedBlock, :libro, :riga

  def viewWillAppear(animated)
    super
    load_data
  end

  def prezzi
    @prezzi ||= begin
      @prezzi = [
        '€ %.2f' % @libro.prezzo_consigliato,
        '€ %.2f' % (@libro.prezzo_copertina.to_f * 0.85),
        '€ %.2f' % (@libro.prezzo_copertina.to_f * 0.80),
        '€ %.2f' % (@libro.prezzo_copertina.to_f * 0.75),
        '€ %.2f' % (@libro.prezzo_copertina.to_f * 0.70),
        '€ %.2f' % @libro.prezzo_copertina,
      ]
    end    
  end

  def sconti
    @sconti ||= [ '€ %.2f' % @libro.prezzo_consigliato, '15', '20', '25', '30' ]
  end  

  def load_data
    table = self.tableView

    (0..5).each do |index|
      cell = table.cellForRowAtIndexPath([0, index].nsindexpath)
      cell.detailTextLabel.text = prezzi[index]
    end

  end

  def check_prezzo

  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)

    # if @appunto.status
    #   previousIndexPath = NSIndexPath.indexPathForRow(STATUSES.index(@appunto.status.split("_").join(" ")), inSection:0)
    #   cell = tableView.cellForRowAtIndexPath(previousIndexPath)
    #   cell.accessoryType = UITableViewCellAccessoryNone
    # end
    
    if indexPath.row < 5
      tableView.cellForRowAtIndexPath(indexPath).accessoryType = UITableViewCellAccessoryCheckmark
      tableView.deselectRowAtIndexPath(indexPath, animated:true)

      text = prezzi[indexPath.row]
      puts text
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

  end

  def close(sender)
    self.navigationController.popViewControllerAnimated(true)
  end
end