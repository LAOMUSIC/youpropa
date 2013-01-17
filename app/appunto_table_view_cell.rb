class AppuntoTableViewCell < UITableViewCell
  

  extend IB

  outlet :clienteLabel
  outlet :destinatarioLabel
  outlet :noteText
  outlet :statusImage

  attr_accessor :appunto

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super
    self.clienteLabel.adjustsFontSizeToFitWidth = true
    self.clienteLabel.textColor = UIColor.darkGrayColor
    self.noteText.font = UIFont.systemFontOfSize 13
    self.noteText.numberOfLines = 0
    self.selectionStyle = UITableViewCellSelectionStyleGray
    self
  end

  def appunto=(appunto)
    @appunto = appunto
    if @appunto
      self.clienteLabel.text = @appunto.cliente_nome
      self.destinatarioLabel.text = "@#{@appunto.destinatario}"
      self.noteText.text = "#{@appunto.note}"
      self.statusImage.setImage UIImage.imageNamed("task-#{@appunto.status}")
      # self.imageView.setImage(stato_image)
      # self.imageView = {url: self.appunto.user.avatar_url.to_url, placeholder: UIImage.imageNamed("profile-image-placeholder")}
      self.setNeedsLayout
    end
    @appunto
  end

  def self.heightForCellWithAppunto(appunto)
    sizeToFit = appunto.note.sizeWithFont(UIFont.systemFontOfSize(13), constrainedToSize: CGSizeMake(200, Float::MAX), lineBreakMode:UILineBreakModeWordWrap)
    
    return [96, sizeToFit.height + 55].max
  end

  def layoutSubviews
    super
    puts "layoutSubviews"
    # self.imageView.frame = CGRectMake(14, 10, 30, 30);
    # self.clienteLabel.frame = CGRectMake(60, 10, 240, 20);
    noteTextLabelFrame = CGRectMake(41, 48, 231, 26);
    noteTextLabelFrame.size.height = self.class.heightForCellWithAppunto(self.appunto) - 55
    self.noteText.frame = noteTextLabelFrame
  end
end