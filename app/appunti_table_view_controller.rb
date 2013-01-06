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
    setupPullToRefresh
    setupSearchBar

    # self.title = "Appunti"
    # self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(self.activityIndicatorView)
    # self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh, target:self, action: 'reload')
    # self.tableView.rowHeight = 70
    # self.reload
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
  


  def reload
    # self.activityIndicatorView.startAnimating
    # self.navigationItem.rightBarButtonItem.enabled = true

    # Appunto.fetchTodopropaAppunti do |appunti, error|
    #   if (error)
    #     UIAlertView.alloc.initWithTitle("Error",
    #       message:error.localizedDescription,
    #       delegate:nil,
    #       cancelButtonTitle:nil,
    #       otherButtonTitles:"OK", nil).show
    #   else
    #     self.appunti = appunti
    #   end

    #   self.activityIndicatorView.stopAnimating
    #   self.navigationItem.rightBarButtonItem.enabled = true
      
    #   doneReloadingTableViewData

    # end
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

  # def loadView
  #   super
  #   self.activityIndicatorView = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhite)
  #   self.activityIndicatorView.hidesWhenStopped = true
  # end




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

  # def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
  #   if cell.appunto.stato == "completato"
  #     cell.backgroundColor = UIColor.groupTableViewBackgroundColor
  #   end  
  # end

  # def tableView(tableView, heightForRowAtIndexPath:indexPath)
  #   AppuntoCell.heightForCellWithPost(@appunti[indexPath.row])
  # end

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