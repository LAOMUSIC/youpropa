class ClasseItem < UICollectionViewCell

  attr_accessor :classe

  def initWithFrame(frame)
    
    super.tap do |cell|
      
      cell.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
      
      @classe_label = UILabel.alloc.initWithFrame([[0, 20], [80, 30]]).tap do |label|
         #label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 1
         label.font = UIFont.boldSystemFontOfSize(20.0)
         label.textAlignment = UITextAlignmentCenter
         label.backgroundColor = UIColor.clearColor
         label.textColor = UIColor.whiteColor
         label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
         cell.contentView.addSubview(label)
      end

      @alunni_label = UILabel.alloc.initWithFrame([[0, 55], [75, 20]]).tap do |label|
         #label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 1
         label.font = UIFont.systemFontOfSize(12.0)
         label.textAlignment = UITextAlignmentRight
         label.backgroundColor = UIColor.clearColor
         label.textColor = UIColor.whiteColor
         label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
         cell.contentView.addSubview(label)
      end

      @adozione_image =  UIImageView.alloc.initWithFrame([[5, 53], [20, 25]]).tap do |imgv|
        #imgv.translatesAutoresizingMaskIntoConstraints = false
        imgv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin
        imgv.backgroundColor = UIColor.clearColor

        imgv.layer.cornerRadius = 5
        imgv.layer.masksToBounds = true


        self.contentView.addSubview(imgv)
      end

      cell.contentView.autoresizesSubviews = true

      # bg = "bgclasse.png".uiimage
      # bgView = UIImageView.alloc.initWithImage bg
      # cell.backgroundView = bgView

      # cell.clipsToBounds = false

      # cell.layer.borderColor = UIColor.yellowColor.CGColor
      # cell.layer.borderWidth = 3
      # cell.layer.cornerRadius = 8
      # cell.layer.masksToBounds = true

      # cell.layer.shadowColor = UIColor.blackColor.CGColor
      # cell.layer.shadowOffset = CGSizeMake(3.0,3.0)
      # cell.layer.shadowOpacity = 0.5
      # cell.layer.shadowRadius = 3.0


      cell.backgroundColor = UIColor.clearColor
      image = UIImage.imageNamed("bgclasse.png")
      cell.layer.backgroundColor = UIColor.colorWithPatternImage(image).CGColor;

      # Rounded corners.
      cell.layer.cornerRadius = 10

      # A thin border.
      cell.layer.borderColor = UIColor.yellowColor.CGColor;
      cell.layer.borderWidth = 3;

      # Drop shadow.
      cell.layer.shadowColor = UIColor.blackColor.CGColor;
      cell.layer.shadowOpacity = 0.5
      cell.layer.shadowRadius = 3.0
      cell.layer.shadowOffset = CGSizeMake(3, 3);


    end
  end
  
  def classe=(classe)
    @classe = classe
    if @classe
      @classe_label.text = "#{@classe.classe} #{@classe.sezione}"
      @alunni_label.text = "#{@classe.nr_alunni}b"

      
      unless @classe.adozioni.empty?
        @adozione_image.hidden = false
        @adozione_image.setImage UIImage.imageNamed("#{@classe.adozioni[0].sigla}.jpeg")
      else
        @adozione_image.hidden = true
      end

    end
    @classe
  end



end