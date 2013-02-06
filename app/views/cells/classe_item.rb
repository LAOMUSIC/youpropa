class ClasseItem < UICollectionViewCell

  attr_accessor :classe

  def initWithFrame(frame)
    
    super.tap do |cell|
      
      cell.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
      
      @classe_label = UILabel.alloc.initWithFrame([[0, 25], [80, 30]]).tap do |label|
         #label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 1
         label.font = UIFont.boldSystemFontOfSize(18.0)
         label.textAlignment = UITextAlignmentCenter
         label.backgroundColor = UIColor.clearColor
         label.textColor = UIColor.darkGrayColor
         label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
         cell.contentView.addSubview(label)
      end
      # cell.contentView.autoresizesSubviews = true
      # bg = "bg.png".uiimage
      # bgView = UIImageView.alloc.initWithImage bg
      # cell.backgroundView = bgView
      cell.backgroundColor = UIColor.grayColor
      cell.layer.borderColor = UIColor.redColor.CGColor
      cell.layer.borderWidth = 3

    end
  end
  
  def classe=(classe)
    @classe = classe
    if @classe
      @classe_label.text = "#{@classe.classe} #{@classe.sezione}"
    end
    @classe
  end



end