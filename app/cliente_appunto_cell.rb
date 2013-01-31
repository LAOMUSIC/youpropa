class ClienteAppuntoCell < UICollectionViewCell

  attr_accessor :label

  def initWithFrame(frame)
    super.tap do
      self.label = UILabel.alloc.initWithFrame(self.bounds)
      #self.autoresizesSubviews = true
      # self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth |                                   UIViewAutoresizingFlexibleHeight
      #self.label.font = UIFont.boldSystemFontOfSize(42)
      #self.label.textAlignment = NSTextAlignmentCenter
      #self.label.adjustsFontSizeToFitWidth(true)
        
      self.addSubview(self.label)
      self.setNumber(0)
    end

    self
  end
  
  def setNumber(number)
    self.label.text = "#{number}"
  end
    
end