class DocenteItem < UICollectionViewCell

  attr_accessor :docente

  def initWithFrame(frame)
    
    super.tap do |cell|
      
      cell.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
      
      @docente_label = UILabel.alloc.initWithFrame([[5, 5], [140, 25]]).tap do |label|
         #label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 1
         label.font = UIFont.boldSystemFontOfSize(17.0)
         label.textAlignment = UITextAlignmentLeft
         label.backgroundColor = UIColor.clearColor
         label.textColor = UIColor.blackColor
         label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
         cell.contentView.addSubview(label)
      end

      @telefono_label = UILabel.alloc.initWithFrame([[5, 30], [140, 20]]).tap do |label|
         #label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 1
         label.font = UIFont.systemFontOfSize(12.0)
         label.textAlignment = UITextAlignmentRight
         label.backgroundColor = UIColor.clearColor
         label.textColor = UIColor.blackColor
         label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
         cell.contentView.addSubview(label)
      end

      cell.contentView.autoresizesSubviews = true

      # cell.backgroundColor = UIColor.clearColor
      # image = UIImage.imageNamed("bgdocente.png")
      # cell.layer.backgroundColor = UIColor.colorWithPatternImage(image).CGColor;

      # Rounded corners.
      cell.layer.cornerRadius = 10

      # A thin border.
      cell.layer.borderColor = UIColor.redColor.CGColor;
      cell.layer.borderWidth = 3;

      # Drop shadow.
      cell.layer.shadowColor = UIColor.blackColor.CGColor;
      cell.layer.shadowOpacity = 0.5
      cell.layer.shadowRadius = 3.0
      cell.layer.shadowOffset = CGSizeMake(3, 3);


    end
  end
  
  def docente=(docente)
    @docente = docente
    if @docente
      @docente_label.text = "#{@docente.docente}"
      @telefono_label.text = "#{@docente.telefono}"
    end
    @docente
  end



end