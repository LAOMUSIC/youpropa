class ClienteAppuntoCell < UICollectionViewCell

  attr_accessor :appunto

  def initWithFrame(frame)
    
    super.tap do |cell|
      
      cell.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
      
      @status_image =  UIImageView.alloc.initWithFrame([[5, 5], [20, 20]]).tap do |imgv|
        #imgv.translatesAutoresizingMaskIntoConstraints = false
        imgv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin
        imgv.backgroundColor = UIColor.clearColor
        cell.contentView.addSubview(imgv)
      end
      
      @destinatario_label = UILabel.alloc.initWithFrame([[10, 35], [150, 15]]).tap do |label|
         #label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 1
         label.font = UIFont.boldSystemFontOfSize(12.0)
         label.textAlignment = UITextAlignmentLeft
         label.backgroundColor = UIColor.clearColor
         label.textColor = UIColor.darkGrayColor
         label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
         cell.contentView.addSubview(label)
      end

      @note_label = UILabel.alloc.initWithFrame([[10, 50], [150, 120]]).tap do |label|
         #label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0
         label.font = UIFont.systemFontOfSize(11.0)
         label.textAlignment = UITextAlignmentLeft
         label.backgroundColor = UIColor.clearColor
         label.textColor = UIColor.darkGrayColor
         label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
         cell.contentView.addSubview(label)
      end

      @data_label = UILabel.alloc.initWithFrame([[120, 5], [45, 15]]).tap do |label|
         #label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0
         label.font          = UIFont.systemFontOfSize(11.0)
         label.textColor     = UIColor.colorWithWhite(0.45, alpha:1.0)
         label.textAlignment = UITextAlignmentRight
         label.shadowColor = UIColor.whiteColor
         label.shadowOffset = CGSizeMake(0, 1);
         label.backgroundColor = UIColor.clearColor
         cell.contentView.addSubview(label)
      end

      @importo_label = UILabel.alloc.initWithFrame([[4, 180], [150, 15]]).tap do |label|
         #label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0
         label.font          = UIFont.systemFontOfSize(11.0)
         label.textAlignment   = UITextAlignmentRight
         label.backgroundColor = UIColor.clearColor
         label.textColor       = UIColor.darkGrayColor
         label.shadowOffset = CGSizeMake(0, 1);
         label.backgroundColor = UIColor.clearColor
         cell.contentView.addSubview(label)
      end

      cell.contentView.autoresizesSubviews = true
      bg = "bg.png".uiimage
      bgView = UIImageView.alloc.initWithImage bg
      cell.backgroundView = bgView
    end
  end
  
  def appunto=(appunto)
    @appunto = appunto
    if @appunto
      @destinatario_label.text = @appunto.destinatario
      @note_label.text = format_appunto
      @importo_label.text = @appunto.righe.empty? ? "" : "#{appunto.totale_copie} copie #{@appunto.importo} €" 
      @data_label.text = format_date @appunto.created_at
      @status_image.setImage UIImage.imageNamed("task-#{@appunto.status}")
      # if @appunto.totale_copie == 0
      #   @customBadge.hidden = true
      # else
      #   @customBadge.hidden = false
      #   @customBadge.autoBadgeSizeWithString("#{@appunto.totale_copie}")
      # end
      # @dataLabel.text = format_date(@appunto.created_at)
      self.setNeedsLayout
    end
    @appunto
  end

  private

    def format_date(date_str)
      formatter = NSDateFormatter.alloc.init
      formatter.setLocale(NSLocale.alloc.initWithLocaleIdentifier("it_IT"))
      formatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ssz")
      date = formatter.dateFromString(date_str)
      formatter.setDateFormat("d MMM")
      date_str = formatter.stringFromDate(date)
      date_str
    end

    def format_appunto
      righeText = ""
      unless @appunto.note.blank?
        righeText += @appunto.note + "\r\n"
      end 
      @appunto.righe.each do |r|
        righeText += "#{r.quantita} - #{r.titolo}\r\n"
      end
      righeText    
    end

end