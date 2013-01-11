class ClientiTableViewController < UITableViewController
  
  extend IB

  attr_accessor :searchResults, :refreshHeaderView

  outlet :searchBar

  def viewDidLoad
    @clienti = []
    @searchResults = []
    view.dataSource = view.delegate = self
    setupPullToRefresh
    setupSearchBar
    true
  end

  def viewDidAppear(animated)
    super
    self.tableView.reloadData
    self.searchDisplayController.searchResultsTableView.reloadData
  end

  def viewWillAppear(animated)
    puts "grabbing all clienti"
    loadFromBackend
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
    App.delegate.backend.getObjectsAtPath("api/v1/clienti",
                                parameters: nil,
                                success: lambda do |operation, result|
                                                  @clienti = result.array
                                                  tableView.reloadData
                                                  doneReloadingTableViewData
                                                end,
                                failure: lambda do |operation, error|
                                                  puts error.localizedDescription
                                                end)
  end

  # Storyboard methods
  def prepareForSegue(segue, sender:sender)

    if segue.identifier.isEqualToString("displayCliente")
      cliente = nil
      if (self.searchDisplayController.isActive)
        indexPath = self.searchDisplayController.searchResultsTableView.indexPathForCell(sender)
        cliente = self.searchDisplayController.searchResultsTableView.cellForRowAtIndexPath(indexPath).cliente
      else
        indexPath = self.tableView.indexPathForCell(sender)
        cliente = self.tableView.cellForRowAtIndexPath(indexPath).cliente
      end  
      segue.destinationViewController.cliente = cliente
      cliente = nil
    end

  end

  # UITableViewController methods


  def tableView(tableView, numberOfRowsInSection:section)
    if (tableView == self.tableView)
      @clienti.count
    else
      @searchResults.count;
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = self.tableView.dequeueReusableCellWithIdentifier("ClienteCell")
    cell ||= ClienteCell.alloc.initWithStyle(UITableViewCellStyleDefault,
                                            reuseIdentifier:"ClienteCell")
    if (tableView == self.tableView)
      cell.cliente = @clienti[indexPath.row]
    else
      cell.cliente = @searchResults[indexPath.row]
    end
    return cell
  end

  # def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  #   cell = tableView.cellForRowAtIndexPath(indexPath)
  #   if (tableView != self.tableView)
  #     self.performSegueWithIdentifier("showForm", sender:cell)
  #   end    
  # end

  # UISearchBar UISearchDisplayController methods
  def searchDisplayController(controller, shouldReloadTableForSearchString:searchString)
    self.filterClientiForTerm(searchString);
    true
  end

  def searchDisplayControllerDidEndSearch(controller)
    view.reloadData
    #loadFromBackend
  end

  def filterClientiForTerm(text)
    @searchResults = @clienti.select do |c|
      index = "#{c.nome} #{c.comune} #{c.frazione}".downcase  
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
