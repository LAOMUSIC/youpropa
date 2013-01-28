class ClienteAppuntiTableView < UITableView

  attr_accessor :cliente

  def tableView(tableView, numberOfRowsInSection:section)
    5
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)

    cell = tableView.dequeueReusableCellWithIdentifier("appuntoClienteCell")
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault,                                                 reuseIdentifier:"appuntoClienteCell")

    # if (tableView == self.tableView)
    #   cell.appunto = @appunti[indexPath.row]
    # else
    #   cell.appunto = @searchResults[indexPath.row]
    # end
    # puts "cellForRowAtIndexPath #{indexPath.row}"
    cell.titleLabel.text = indexPath.row.to_s
    cell
  end


end  