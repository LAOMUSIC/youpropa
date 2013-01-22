class RigheTableViewController < UITableViewController
	
  attr_accessor :appunto

    # UITableViewDelegate

  def tableView(tableView, numberOfRowsInSection:section)
    @appunto.righe.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)

    cell = tableView.dequeueReusableCellWithIdentifier("righeTableViewCell")
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyle1,
                                            reuseIdentifier:"righeTableViewCell")

    riga = @appunto.righe[indexPath.row]
    cell.textLabel.text = riga.titolo
    cell.detailTextLabel.text = "#{riga.quantita} #{riga.prezzo_unitario}"
    cell
  end

  # def tableView(tableView, heightForRowAtIndexPath:indexPath)
  #   puts "heightForRowAtIndexPath #{indexPath.row}"
  #   AppuntoTableViewCell.heightForCellWithAppunto(@appunti[indexPath.row])
  # end

  # def tableView(tableView, commitEditingStyle:editing_style, forRowAtIndexPath:indexPath)
  #   if editing_style == UITableViewCellEditingStyleDelete
  #     editing_style = "UITableViewCellEditingStyleDelete"
  #     delete_appunto(self.tableView.cellForRowAtIndexPath(indexPath).appunto)
  #     @appunti.delete_at(indexPath.row)
  #     self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationAutomatic)
  #   end
  # end

  # def delete_appunto(appunto)
  #   puts "Deleting cliente #{appunto.remote_id}"
  #   App.delegate.backend.deleteObject(appunto, path:nil, parameters:nil,
  #                             success: lambda do |operation, result|
  #                                         puts "deleted"  
  #                                      end,
  #                             failure: lambda do |operation, error|
  #                                               App.alert error.localizedDescription
  #                                             end)
  # end

  # def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  #   tableView.deselectRowAtIndexPath(indexPath, animated:true)
  # end

end