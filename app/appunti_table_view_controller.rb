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

    if segue.identifier.isEqualToString("displayAppunto")
      appunto = nil
      if (self.searchDisplayController.isActive)
        indexPath = self.searchDisplayController.searchResultsTableView.indexPathForCell(sender)
        appunto = self.searchDisplayController.searchResultsTableView.cellForRowAtIndexPath(indexPath).appunto
      else
        indexPath = self.tableView.indexPathForCell(sender)
        appunto = self.tableView.cellForRowAtIndexPath(indexPath).appunto
      end
      puts "status #{appunto.status}  "
      segue.destinationViewController.appunto = appunto
      appunto = nil
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
    App.delegate.backend.getObjectsAtPath("api/v1/appunti",
                                parameters: nil,
                                success: lambda do |operation, result|
                                                  @appunti = result.array
                                                  tableView.reloadData
                                                  doneReloadingTableViewData
                                                end,
                                failure: lambda do |operation, error|
                                                  puts error.localizedDescription
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

    cell = self.tableView.dequeueReusableCellWithIdentifier("AppuntoCell")
    cell || AppuntoCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:"AppuntoCell")
    
    if (tableView == self.tableView)
      cell.appunto = @appunti[indexPath.row]
    else
      cell.appunto = @searchResults[indexPath.row]
    end
    cell
  end

  def tableView(tableView, commitEditingStyle:editing_style, forRowAtIndexPath:indexPath)
    if editing_style == UITableViewCellEditingStyleDelete
      editing_style = "UITableViewCellEditingStyleDelete"
      
      #@appunti.delete_at(index_path.row)
      delete_appunto(self.tableView.cellForRowAtIndexPath(indexPath).appunto)
      #@appunti.delete_at(index_path.row)
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

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
  end


  # UISearchBar UISearchDisplayController methods
  def searchDisplayController(controller, shouldReloadTableForSearchString:searchString)
    self.filterAppuntiForTerm(searchString);
    true
  end

  def searchDisplayControllerDidEndSearch(controller)
    view.reloadData
    #loadFromBackend
  end

  def filterAppuntiForTerm(text)
    @searchResults = @appunti.select do |c| 
      condition = text.downcase
      c.destinatario.downcase.include?( condition ) ||
        c.cliente_nome.downcase.include?( condition) ||
          c.note.downcase.include? (condition)
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