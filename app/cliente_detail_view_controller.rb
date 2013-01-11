class ClienteDetailViewController < UIViewController

  extend IB

  attr_accessor :cliente

  outlet :nomeLabel
  outlet :indirizzoLabel
  outlet :cittaLabel

  outlet :navigaButton
  outlet :emailButton
  outlet :callButton

  def viewDidLoad

  end

  def viewWillAppear(animated)
    super
    load_cliente if @cliente
  end

  def load_cliente
    nomeLabel.text = cliente.nome
    indirizzoLabel.text = cliente.indirizzo
    cittaLabel.text = "#{cliente.cap} #{cliente.citta} #{cliente.provincia}"

    if cliente.telefono.blank?
      callButton.enabled = false
      callButton.alpha = 0.5
    end
    if cliente.email.blank?
      emailButton.enabled = false
      emailButton.alpha = 0.5
    end

  end

  def prepareForSegue(segue, sender:sender)
    if segue.identifier.isEqualToString("showForm")
      segue.destinationViewController.cliente_id = @cliente.remote_id
    end
    if segue.identifier.isEqualToString("nuovoAppunto")
      segue.destinationViewController.cliente = @cliente
    end
  end

  def navigate(sender)
    url = NSURL.URLWithString("http://maps.apple.com/maps?q=#{@cliente.latitude},#{@cliente.longitude}")
    UIApplication.sharedApplication.openURL(url);
  end  

  def makeCall(sender)
    url = NSURL.URLWithString("tel://#{@cliente.telefono.split(" ").join}")
    UIApplication.sharedApplication.openURL(url);
  end  

  def sendEmail(sender)
    url = NSURL.URLWithString("mailto://#{@cliente.email}")
    UIApplication.sharedApplication.openURL(url);
  end  


end