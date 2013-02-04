class AppuntoCell < UITableViewCell
  
  attr_reader :appunto

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super
    setupBackground
    addStatusImage
    addClienteLabel
    addDestinatarioLabel
    addNoteLabel
    addDataLabel
    addBadge
    self
  end

  def appunto=(appunto)
    @appunto = appunto
    if @appunto
      @clienteLabel.text = @appunto.cliente_nome
      @destinatarioLabel.text = "#{@appunto.destinatario}"
      @noteLabel.text = "#{@appunto.note}"
      @statusImage.setImage UIImage.imageNamed("task-#{@appunto.status}")
      if @appunto.totale_copie == 0
        @customBadge.hidden = true
      else
        @customBadge.hidden = false
        @customBadge.autoBadgeSizeWithString("#{@appunto.totale_copie}")
      end
      @dataLabel.text = format_date(@appunto.created_at)
      self.setNeedsLayout
    end
    @appunto
  end

  def layoutSubviews
    super
    @statusImage.frame       = CGRectMake(7, 33, 25, 25)
    @clienteLabel.frame      = CGRectMake(48, 8, 185, 21)
    @destinatarioLabel.frame = CGRectMake(48, 35, 231, 21)
    @noteLabel.frame         = CGRectMake(48, 60, 231, 21)
    @dataLabel.frame         = CGRectMake(246, 8, 42, 21) 
    @customBadge.frame = CGRectMake(288 - @customBadge.frame.size.width, 34, @customBadge.frame.size.width, @customBadge.frame.size.height)
  end

  def setSelected(selected, animated:animated)
    super
    setShadowOffset(selected)
  end

  def setHighlighted(highlighted, animated:animated)
    super
    setShadowOffset(highlighted)
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

    def setShadowOffset(value)
      shadowOffset = value ? CGSizeZero : CGSizeMake(0, 1)
      @clienteLabel.shadowOffset = shadowOffset
      @destinatarioLabel.shadowOffset = shadowOffset
      @noteLabel.shadowOffset = shadowOffset
    end
    
    def setupBackground
      bg = "bg.png".uiimage
      bgView = UIImageView.alloc.initWithImage bg
      self.backgroundView = bgView
    end

    def addStatusImage
      @statusImage = UIImageView.alloc.init
      self.contentView.addSubview(@statusImage)
    end  

    def addClienteLabel
      @clienteLabel = UILabel.alloc.init
      @clienteLabel.font         = UIFont.boldSystemFontOfSize(16)
      @clienteLabel.textColor    = UIColor.colorWithWhite(0.35, alpha:1.0)
      @clienteLabel.shadowColor  = UIColor.whiteColor
      @clienteLabel.shadowOffset = CGSizeMake(0, 1)
      @clienteLabel.backgroundColor = UIColor.clearColor
      @clienteLabel.highlightedTextColor = UIColor.whiteColor
      self.contentView.addSubview(@clienteLabel)
    end


    def addDestinatarioLabel
      @destinatarioLabel = UILabel.alloc.init
      @destinatarioLabel.font = UIFont.boldSystemFontOfSize(14)
      @destinatarioLabel.textColor = UIColor.colorWithWhite(0.55, alpha:1.0)
      @destinatarioLabel.shadowColor = UIColor.whiteColor
      @destinatarioLabel.shadowOffset = CGSizeMake(0, 1);
      @destinatarioLabel.backgroundColor = UIColor.clearColor
      @destinatarioLabel.highlightedTextColor = UIColor.whiteColor
      self.contentView.addSubview(@destinatarioLabel)
    end

    def addNoteLabel
      @noteLabel = UILabel.alloc.init
      @noteLabel.font = UIFont.boldSystemFontOfSize(12)
      @noteLabel.textColor = UIColor.colorWithWhite(0.55, alpha:1.0)
      @noteLabel.shadowColor = UIColor.whiteColor
      @noteLabel.shadowOffset = CGSizeMake(0, 1);
      @noteLabel.backgroundColor = UIColor.clearColor
      @noteLabel.highlightedTextColor = UIColor.whiteColor
      self.contentView.addSubview(@noteLabel)
    end

    def addDataLabel
      @dataLabel = UILabel.alloc.init
      @dataLabel.font = UIFont.systemFontOfSize(12)
      @dataLabel.textColor = UIColor.colorWithWhite(0.45, alpha:1.0)
      @dataLabel.textAlignment = UITextAlignmentRight
      @dataLabel.shadowColor = UIColor.whiteColor
      @dataLabel.shadowOffset = CGSizeMake(0, 1);
      @dataLabel.backgroundColor = UIColor.clearColor
      @dataLabel.highlightedTextColor = UIColor.whiteColor
      self.contentView.addSubview(@dataLabel)
    end

    def addBadge

      @customBadge = CustomBadge.customBadgeWithString("0", 
                           withStringColor:UIColor.whiteColor, 
                            withInsetColor:UIColor.redColor,
                            withBadgeFrame:true,
                       withBadgeFrameColor:UIColor.whiteColor, 
                             withScale:1,
                           withShining:true)
        

      self.contentView.addSubview(@customBadge) 
    end

end