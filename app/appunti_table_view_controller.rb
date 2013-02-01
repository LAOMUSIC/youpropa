class AppuntiTableViewController < UITableViewController
  
  extend IB

  attr_accessor :searchResults, :refreshHeaderView

  outlet :searchBar

  attr_accessor :activityIndicatorView

  def viewDidLoad
    super
    @appunti = []
    @searchResults = []
    view.dataSource = view.delegate = self

    self.navigationItem.rightBarButtonItem = self.editButtonItem

    setupPullToRefresh
    setupSearchBar

    self.tableView.registerClass(AppuntoCell, forCellReuseIdentifier:"appuntoCell")

    # non va non capisco
    #self.tableView.registerClass(AppuntoTableViewCell, forCellReuseIdentifier:"appuntoTableViewCell")

  end

  def viewDidAppear(animated)
    super
    view.reloadData
  end

  def viewWillAppear(animated)
    puts "grabbing all appunti"
    loadFromBackend
  end

  # def viewDidUnload
  #   self.activityIndicatorView = nil
  #   super
  # end
  
 # def edit(sender)
 #   self.setEditing(true, animated:true)
 # end


  # Storyboard methods
  def prepareForSegue(segue, sender:sender)

    if (self.searchDisplayController.isActive)
      indexPath = self.searchDisplayController.searchResultsTableView.indexPathForCell(sender)
      appunto = self.searchDisplayController.searchResultsTableView.cellForRowAtIndexPath(indexPath).appunto
    else
      indexPath = self.tableView.indexPathForCell(sender)
      appunto = self.tableView.cellForRowAtIndexPath(indexPath).appunto
    end
    
    puts "cliente_id #{appunto.cliente_id} appunto_id #{appunto.remote_id}"

    if segue.identifier.isEqualToString("displayAppunto")
      segue.destinationViewController.appunto = appunto

    elsif segue.identifier.isEqualToString("modalAppunto")
      segue.destinationViewController.visibleViewController.appunto = appunto
    end


  end


  def setupPullToRefresh
    @refreshHeaderView ||= begin
      rhv = RefreshTableHeaderView.alloc.initWithFrame(CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
      rhv.delegate = self
      rhv.refreshLastUpdatedDate    
      tableView.addSubview(rhv)
      rhv
    end
  end

  def setupSearchBar
    offset = CGPointMake(0, self.searchBar.frame.size.height)
    self.tableView.contentOffset = offset
  end

  def loadFromBackend
    SVProgressHUD.show
    App.delegate.backend.getObjectsAtPath("api/v1/appunti",
                                parameters: nil,
                                success: lambda do |operation, result|
                                                  @appunti = result.array
                                                  tableView.reloadData
                                                  doneReloadingTableViewData
                                                  SVProgressHUD.dismiss
                                                end,
                                failure: lambda do |operation, error|
                                                  SVProgressHUD.showErrorWithStatus("#{error.localizedDescription}")
                                                end)
  end

  # UITableViewDelegate

  def tableView(tableView, numberOfRowsInSection:section)
    if (tableView == self.tableView)
      @appunti.count
    else
      @searchResults.count;
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)

    cell = self.tableView.dequeueReusableCellWithIdentifier("appuntoCell")
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

    # senza regiterClass in init per altro sistemare altezza
    # cell = tableView.dequeueReusableCellWithIdentifier("appuntoTableViewCell")
    # cell ||= AppuntoTableViewCell.alloc.initWithStyle(UITableViewCellStyleCustom,
    #                                           reuseIdentifier:"appuntoTableViewCell")

    if (tableView == self.tableView)
      cell.appunto = @appunti[indexPath.row]
    else
      cell.appunto = @searchResults[indexPath.row]
    end
    cell
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    95
    #AppuntoTableViewCell.heightForCellWithAppunto(@appunti[indexPath.row])
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    cell = tableView.cellForRowAtIndexPath(indexPath)
    if Device.ipad?
      self.performSegueWithIdentifier("modalAppunto", sender:cell )
    else
      self.performSegueWithIdentifier("displayAppunto", sender:cell )
    end
  end

  def tableView(tableView, commitEditingStyle:editing_style, forRowAtIndexPath:indexPath)
    if editing_style == UITableViewCellEditingStyleDelete
      editing_style = "UITableViewCellEditingStyleDelete"
      delete_appunto(self.tableView.cellForRowAtIndexPath(indexPath).appunto)
      @appunti.delete_at(indexPath.row)
      self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationAutomatic)
    end
  end

  def delete_appunto(appunto)
    puts "Deleting cliente #{appunto.remote_id}"
    App.delegate.backend.deleteObject(appunto, path:nil, parameters:nil,
                              success: lambda do |operation, result|
                                          puts "deleted"  
                                       end,
                              failure: lambda do |operation, error|
                                                App.alert error.localizedDescription
                                              end)
  end


  # UISearchBar UISearchDisplayController methods
  def searchDisplayController(controller, shouldReloadTableForSearchString:searchString)
    self.filterAppuntiForTerm(searchString);
    true
  end

  def searchDisplayControllerDidEndSearch(controller)
    view.reloadData
  end

  def filterAppuntiForTerm(text)
    @searchResults = @appunti.select do |c| 
      condition = text.downcase
      index = "#{c.destinatario} #{c.cliente_nome} #{c.note}"
      index.downcase.include?( condition ) 
    end  
    view.reloadData
  end










  ## PullToRefresh
 
  def reloadTableViewDataSource
    @reloading = true
  end
  
  def doneReloadingTableViewData
    
    @reloading = false
    @refreshHeaderView.refreshScrollViewDataSourceDidFinishLoading(self.tableView)
  end
  
  def scrollViewDidScroll(scrollView)
    @refreshHeaderView.refreshScrollViewDidScroll(scrollView)
  end
  
  def scrollViewDidEndDragging(scrollView, willDecelerate:decelerate)
    @refreshHeaderView.refreshScrollViewDidEndDragging(scrollView)
  end
  
  def refreshTableHeaderDidTriggerRefresh(view)
    self.reloadTableViewDataSource
    self.performSelector('loadFromBackend', withObject:nil, afterDelay:0)
  end
    
  def refreshTableHeaderDataSourceIsLoading(view)
    @reloading
  end
  
  def refreshTableHeaderDataSourceLastUpdated(view)
    NSDate.date
  end

end