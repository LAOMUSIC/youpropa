class RigheTableViewController < UITableViewController
	
  attr_accessor :appunto

  def viewDidLoad
    super
    self.navigationItem.rightBarButtonItem = self.editButtonItem
  end

  def viewWillAppear(animated)
    super
    self.tableView.reloadData
  end

  # Storyboard methods

  def prepareForSegue(segue, sender:sender)
    if segue.identifier.isEqualToString("addRiga") 
      @riga = Riga.new( remote_appunto_id: @appunto.remote_id )
    elsif segue.identifier.isEqualToString("editRiga") 
      indexPath = self.tableView.indexPathForCell(sender)
      @riga = self.tableView.cellForRowAtIndexPath(indexPath).riga
    end
    segue.destinationViewController.appunto = @appunto
    segue.destinationViewController.riga    = @riga

  end

  # def edit(sender)
  #   self.setEditing(true, animated:true)
  # end

  # UITableViewDelegate
  
  def numberOfSectionsInTableView(tableView)
    if @appunto.righe.empty?
      1
    else
      2
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    if section == 0
      1
    else
      @appunto.righe.count
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)

    if indexPath.section == 1
      cell = tableView.dequeueReusableCellWithIdentifier("righeTableViewCell")
      cell ||= RigaTableViewCell.alloc.initWithStyle(UITableViewCellStyle1,
                                              reuseIdentifier:"righeTableViewCell")
      riga = @appunto.righe[indexPath.row]
      cell.riga = riga
    else
      cell = tableView.dequeueReusableCellWithIdentifier("addRigaCell")
      cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault,
                                              reuseIdentifier:"addRigaCell")
    end
    cell  
  end

  # def tableView(tableView, heightForRowAtIndexPath:indexPath)
  #   puts "heightForRowAtIndexPath #{indexPath.row}"
  #   AppuntoTableViewCell.heightForCellWithAppunto(@appunti[indexPath.row])
  # end

  def tableView(tableView, canEditRowAtIndexPath:indexPath) 
    return self.isEditing && indexPath.section == 1
  end

  def tableView(tableView, commitEditingStyle:editing_style, forRowAtIndexPath:indexPath)
    
    if indexPath.section == 1
      if editing_style == UITableViewCellEditingStyleDelete
        editing_style = "UITableViewCellEditingStyleDelete"
        
        delete_riga(self.tableView.cellForRowAtIndexPath(indexPath).riga)

        appunto.righe.delete_at(indexPath.row)

        if appunto.righe.count > 0
          self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationAutomatic)
        else
          tableView.deleteSections(NSIndexSet.indexSetWithIndex(1), withRowAnimation:UITableViewRowAnimationFade)
          tableView.reloadData
        end
      end
    end
  end

  def delete_riga(riga)
    puts "Deleting riga #{riga.remote_id}"
    App.delegate.backend.deleteObject(riga, path:nil, parameters:nil,
                              success: lambda do |operation, result|
                                          puts "deleted"  
                                       end,
                              failure: lambda do |operation, error|
                                                App.alert error.localizedDescription
                                              end)
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
  end


end