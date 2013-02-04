class LibroCell < UITableViewCell
  
  attr_reader :libro
  
  def libro=(libro)
    @libro = libro
    textLabel.text = @libro.titolo
    detailTextLabel.text = @libro.settore
  end

end