class LibriTableViewController < UITableViewController
  
  extend IB

  attr_accessor :riga
  attr_accessor :searchResults, :refreshHeaderView, :detailViewController

  outlet :searchBar

  def viewDidLoad
    super
    @libri = []
    @searchResults = []
    view.dataSource = view.delegate = self
    setupPullToRefresh
    setupSearchBar
    if Device.ipad?
      self.detailViewController = self.splitViewController.viewControllers.lastObject.topViewController
    end
    true
  end

  def viewDidAppear(animated)
    super
    self.tableView.reloadData
    self.searchDisplayController.searchResultsTableView.reloadData

    self.searchBar.becomeFirstResponder
  end

  def viewWillAppear(animated)
    puts "grabbing all libri"
    loadFromBackend
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    true
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
    App.delegate.backend.getObjectsAtPath("api/v1/libri",
                                parameters: nil,
                                success: lambda do |operation, result|
                                                  @libri = result.array
                                                  tableView.reloadData
                                                  doneReloadingTableViewData
                                                end,
                                failure: lambda do |operation, error|
                                                  puts error.localizedDescription
                                                end)
  end

  # Storyboard methods
  def prepareForSegue(segue, sender:sender)

    if (self.searchDisplayController.isActive)
      indexPath = self.searchDisplayController.searchResultsTableView.indexPathForCell(sender)
      libro = self.searchDisplayController.searchResultsTableView.cellForRowAtIndexPath(indexPath).libro
    else
      indexPath = self.tableView.indexPathForCell(sender)
      libro = self.tableView.cellForRowAtIndexPath(indexPath).libro
    end

    riga.libro_id = libro.remote_id
    riga.titolo   = libro.titolo
    riga.prezzo_copertina = libro.prezzo_copertina
    riga.prezzo_unitario  = libro.prezzo_consigliato
    riga.sconto = 0
    riga.quantita = 1

    segue.destinationViewController.riga  = riga  
    #segue.destinationViewController.libro = libro

  end

  # UITableViewController methods


  def tableView(tableView, numberOfRowsInSection:section)
    if (tableView == self.tableView)
      @libri.count
    else
      @searchResults.count;
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = self.tableView.dequeueReusableCellWithIdentifier("libroCell")
    cell ||= LibroCell.alloc.initWithStyle(UITableViewCellStyleDefault,
                                            reuseIdentifier:"libroCell")
    if (tableView == self.tableView)
      cell.libro = @libri[indexPath.row]
    else
      cell.libro = @searchResults[indexPath.row]
    end
    return cell
  end

  # def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    
  #   if Device.ipad?
  #     if (self.searchDisplayController.isActive)
  #       object = @searchResults[indexPath.row];
  #     else
  #       object = @libri[indexPath.row];
  #     end
  #     self.detailViewController.libro = object
  #     self.detailViewController.load_libro
  #   end
 
  # end

  # UISearchBar UISearchDisplayController methods
  def searchDisplayController(controller, shouldReloadTableForSearchString:searchString)
    self.filterLibriForTerm(searchString);
    true
  end

  def searchDisplayControllerDidEndSearch(controller)
    view.reloadData
    #loadFromBackend
  end

  def filterLibriForTerm(text)
    @searchResults = @libri.select do |c|
      index = "#{c.titolo}".downcase  
      condition = text.downcase
      index.include?( condition )
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
