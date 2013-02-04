class ClienteDetailViewController < UIViewController

  extend IB

  attr_accessor :cliente, :popoverViewController

  outlet :nomeLabel
  outlet :indirizzoLabel
  outlet :cittaLabel
  outlet :nuovoAppuntoButton
  outlet :navigaButton
  outlet :emailButton
  outlet :callButton

  outlet :appuntiTableView

  def viewDidLoad
    super

    self.nuovoAppuntoButton.text = "Nuovo Appunto"
    self.nuovoAppuntoButton.textColor = UIColor.whiteColor
    self.nuovoAppuntoButton.textShadowColor = UIColor.darkGrayColor
    self.nuovoAppuntoButton.tintColor = UIColor.colorWithRed(0.45, green:0, blue:0, alpha:1)
    self.nuovoAppuntoButton.highlightedTintColor = UIColor.colorWithRed(0.75, green:0, blue:0, alpha:1)
    #self.nuovoAppuntoButton.rightAccessoryImage = [UIImage imageNamed:@"arrow"];

    self.navigaButton.text = "Naviga"
    self.emailButton.text  = "Email"
    self.callButton.text   = "Chiama"

    if Device.ipad?
      self.appuntiTableView.registerClass( ClienteAppuntoCell, forCellWithReuseIdentifier:"clienteAppuntoCell")

      self.appuntiTableView.registerClass(UICollectionReusableView, 
           forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, 
                  withReuseIdentifier: "headerDaFare")

      self.appuntiTableView.collectionViewLayout = LineLayout.alloc.init
    end
  end

  def load_appunti
    puts "loadAppunti"
    if @cliente && !@cliente.remote_id.blank?
      App.delegate.backend.getObject(@cliente, path:nil, parameters:nil, 
                              success: lambda do |operation, result|
                                                @cliente.appunti = result.firstObject.appunti
                                                self.appuntiTableView.reloadData
                                              end,
                              failure: lambda do |operation, error|
                                                puts error
                                                #App.delegate.alert error.localizedDescription
                                              end)
    end
  end

  def viewWillAppear(animated)
    super
    load_cliente if @cliente
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    true
  end

  def load_cliente
    nomeLabel.text = cliente.nome
    indirizzoLabel.text = cliente.indirizzo
    cittaLabel.text = "#{cliente.cap} #{cliente.citta} #{cliente.provincia}"

    if cliente.telefono.blank?
      callButton.enabled = false
      #callButton.alpha = 0.5
    end
    if cliente.email.blank?
      emailButton.enabled = false
      #emailButton.alpha = 0.5
    end

    if Device.ipad?
      load_appunti
    end


    if self.popoverViewController
      self.popoverViewController.dismissPopoverAnimated(true)
    end  
  end

  def prepareForSegue(segue, sender:sender)
    if segue.identifier.isEqualToString("showForm")
      segue.destinationViewController.remote_cliente_id = @cliente.remote_id
    end
    
    if segue.identifier.isEqualToString("nuovoAppunto")
      if Device.ipad?
        segue.destinationViewController.visibleViewController.presentedAsModal = true
        segue.destinationViewController.visibleViewController.setSaveBlock( lambda do
          self.load_appunti
        end)

        if sender.class == Appunto
          segue.destinationViewController.visibleViewController.appunto = sender
        end

        segue.destinationViewController.visibleViewController.cliente = @cliente
      else
        segue.destinationViewController.cliente = @cliente
      end
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


  def numberOfSectionsInCollectionView(collectionView)
    1
  end


  def collectionView(collectionView, numberOfItemsInSection:section)
    case section
    when 0
      if @cliente && @cliente.appunti
        @cliente.appunti.count
      else
        0
      end
    when 1
      return 20
    when 2
      return 35
    end
  end

  def collectionView(collectionView, cellForItemAtIndexPath:indexPath)
    
    if indexPath.section == 0
      cell = collectionView.dequeueReusableCellWithReuseIdentifier("clienteAppuntoCell",
                                                                       forIndexPath:indexPath)
      cell.appunto =  @cliente.appunti[indexPath.row]
    end
    cell
  end

  def collectionView(collectionView, viewForSupplementaryElementOfKind:kind, atIndexPath:indexPath)

    if kind == UICollectionElementKindSectionHeader
      return collectionView.dequeueReusableSupplementaryViewOfKind(kind, 
                                                      withReuseIdentifier:"headerDaFare", 
                                                             forIndexPath:indexPath)
    end

  end

  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    
    appunto = @cliente.appunti[indexPath.row]

    self.performSegueWithIdentifier("nuovoAppunto", sender:appunto)

  end


  # splitView delegates

  def splitViewController(svc, shouldHideViewController:vc, inOrientation:orientation)
    return false
  end

  # def splitViewController(svc, willHideViewController:vc, withBarButtonItem:barButtonItem, forPopoverController:pc)
  #   barButtonItem.title = "Menu"
  #   self.navigationItem.setLeftBarButtonItem(barButtonItem)
  #   self.popoverViewController = pc
  # end
  
  # def splitViewController(svc, willShowViewController:avc, invalidatingBarButtonItem:barButtonItem) 
  #   self.navigationItem.setLeftBarButtonItems([], animated:false)
  #   self.popoverViewController = nil
  # end


end