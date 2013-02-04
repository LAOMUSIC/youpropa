class LibriTableViewController < UITableViewController
  
  extend IB

  attr_accessor :riga, :appunto
  attr_accessor :searchResults, :refreshHeaderView, :detailViewController

  outlet :searchBar

  def viewDidLoad
    super
    @libri = []
    @searchResults = []
    view.dataSource = view.delegate = self
  end

  def viewDidAppear(animated)
    super
    self.searchBar.becomeFirstResponder
  end

  def viewWillAppear(animated)
    if @libri.empty?
      puts "grabbing all libri"
      loadFromBackend
    end
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    true
  end

  def loadFromBackend
    App.delegate.backend.getObjectsAtPath("api/v1/libri",
                                parameters: nil,
                                success: lambda do |operation, result|
                                                  @libri = result.array
                                                  @searchResults = result.array
                                                  tableView.reloadData
                                                end,
                                failure: lambda do |operation, error|
                                                  puts error.localizedDescription
                                                end)
  end

  # Storyboard methods
  def prepareForSegue(segue, sender:sender)

    indexPath = self.tableView.indexPathForCell(sender)
    libro = self.tableView.cellForRowAtIndexPath(indexPath).libro

    riga.libro_id = libro.remote_id
    riga.titolo   = libro.titolo
    riga.prezzo_copertina    = libro.prezzo_copertina
    riga.prezzo_unitario     = libro.prezzo_consigliato
    riga.prezzo_consigliato  = libro.prezzo_consigliato
    riga.sconto   = 0
    riga.quantita = 1
    
    segue.destinationViewController.riga  = riga  
    segue.destinationViewController.appunto = appunto
  
  end

  # UITableViewController methods


  def tableView(tableView, numberOfRowsInSection:section)
    @searchResults.count;
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = self.tableView.dequeueReusableCellWithIdentifier("libroCell")
    cell ||= LibroCell.alloc.initWithStyle(UITableViewCellStyleDefault,
                                            reuseIdentifier:"libroCell")
    cell.libro = @searchResults[indexPath.row]
    return cell
  end


  # UISearchBar methods
  def searchBar(searchBar, textDidChange:searchString)
    puts "textDidChange"
    self.filterLibriForTerm(searchString);
    true
  end

  def filterLibriForTerm(text)
    @searchResults = @libri.select do |c|
      index = "#{c.titolo}".downcase  
      condition = text.downcase
      index.include?( condition )
    end  
    view.reloadData
  end



end
