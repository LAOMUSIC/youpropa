class TAXModalPickerView < UIView

  BSMODALPICKER_PANEL_HEIGHT     = 200
  BSMODALPICKER_TOOLBAR_HEIGHT   = 40
  BSMODALPICKER_BACKDROP_OPACITY = 0.8

  attr_accessor :selectedIndex
  attr_accessor :selectedValue
  attr_accessor :values
  attr_accessor :callbackBlock

  # Initializes a new instance of the picker with the values to present to the user.
  #  (Note: call presentInView:withBlock: or presentInWindowWithBlock: to display the control)
  def initWithValues(values)
    init
    self.values = values
    self.userInteractionEnabled = true
    self
  end
  
  def setValues(values)
    @values = values
    if @values
      if @picker
        @picker.reloadAllComponents
      end
    end 
  end

  def setSelectedIndex(selectedIndex)
    @selectedIndex = selectedIndex
    if @picker
      @picker.selectRow(selectedIndex, inComponent:0, animated:true)
    end
  end

  def setSelectedValue(selectedValue)
    index = self.values.indexOfObject(selectedValue)
    self.setSelectedIndex(index)
  end

  def selectedValue
    self.values.objectAtIndex(self.selectedIndex)
  end

  # Presents the control embedded in the provided view.
  #  Arguments:
  #    view        - The view that will contain the control.
  #    callback    - The block that will receive the result of the user action. 
  def presentInView(view, withBlock:callback)
    #view.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated:true)
    
    self.frame = CGRectMake(0, 0, 
                      UIScreen.mainScreen.applicationFrame.size.width,
                      UIScreen.mainScreen.applicationFrame.size.height - 85)  
    #self.frame = UIScreen.mainScreen.applicationFrame
    
    self.callbackBlock = callback;
    
    puts self.bounds.size

    @panel.removeFromSuperview if @panel
    @backdropView.removeFromSuperview if @backdropView
    
    @panel = UIView.alloc.initWithFrame(CGRectMake(0, self.bounds.size.height - BSMODALPICKER_PANEL_HEIGHT, self.bounds.size.width, BSMODALPICKER_PANEL_HEIGHT))
    
    @picker = self.loadPicker
    @toolbar = self.toolbar
    @backdropView = self.backdropView

    self.addSubview(@backdropView)
    @panel.addSubview(@picker)
    @panel.addSubview(@toolbar)
    
    self.addSubview(@panel)
    view.addSubview(self)
    
    oldFrame = @panel.frame;
    newFrame = @panel.frame;
    newFrame.origin.y += newFrame.size.height
    @panel.frame = newFrame
    
    UIView.animateWithDuration(0.25, 
                                delay:0,
                              options:UIViewAnimationCurveEaseOut,
                           animations:lambda do
                               @panel.frame = oldFrame
                               @backdropView.alpha = 1
                             end,
                           completion: lambda do |finished|
                               
                             end
                           )

  end

  # Presents the control embedded in the window.
  # Arguments:
  #   callback    - The block that will receive the result of the user action. 
  def presentInWindowWithBlock(callback)
    appDelegate = App.delegate
    if (appDelegate.respondsToSelector("window")) 
        window = appDelegate.window
        self.presentInView(window, withBlock:callback)
    else
      NSException.exceptionWithName("Can't find a window property on App Delegate.  Please use the presentInView:withBlock: method", reason:"The app delegate does not contain a window method", userInfo:nil)
    end
  end

  def onCancel(sender)
    self.callbackBlock.call(false, "")
    self.dismissPicker
  end    

  def onDone(sender)
    self.callbackBlock.call(true, self.selectedValue)
    self.dismissPicker
  end

  def onBackdropTap(sender)
    self.onCancel(sender)
  end

  def dismissPicker
    UIView.animateWithDuration(0.25, delay:0,
                        options:UIViewAnimationCurveEaseOut,
                     animations: lambda do
                         newFrame = @panel.frame
                         newFrame.origin.y += @panel.frame.size.height
                         @panel.frame = newFrame
                         @backdropView.alpha = 0
                       end,
                     completion: lambda do |finished|
                         @panel.removeFromSuperview
                         @panel = nil

                         @backdropView.removeFromSuperview
                         @backdropView = nil
                         
                         self.removeFromSuperview
                      end)
  end

  def loadPicker
    picker = UIPickerView.alloc.initWithFrame(CGRectMake(0, BSMODALPICKER_TOOLBAR_HEIGHT, self.bounds.size.width, BSMODALPICKER_PANEL_HEIGHT - BSMODALPICKER_TOOLBAR_HEIGHT))
    
    picker.dataSource = self
    picker.delegate = self
    picker.showsSelectionIndicator = true;
    picker.selectRow(@selectedIndex.to_i, inComponent:0, animated:false)
    puts "selectedIndex = #{@selectedIndex}"
    picker
  end
  
  def toolbar
    toolbar = UIToolbar.alloc.initWithFrame(CGRectMake(0, 0, self.bounds.size.width, BSMODALPICKER_TOOLBAR_HEIGHT))
    toolbar.barStyle = UIBarStyleBlackTranslucent
    btnCancel = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCancel, target:self, action:"onCancel:")
    sep =     UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
    btnDone = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone, target:self, action:"onDone:")

    btnDone.title = "Ok"
    toolbar.items = [ btnCancel, sep, btnDone]
    toolbar
  end
  
  def backdropView

    backdropView = UIView.alloc.initWithFrame(self.bounds)
    backdropView.backgroundColor = UIColor.colorWithWhite(0, alpha:BSMODALPICKER_BACKDROP_OPACITY)
    backdropView.alpha = 0
    
    tapRecognizer = UITapGestureRecognizer.alloc.initWithTarget(self,action:"onBackdropTap:")
    backdropView.addGestureRecognizer(tapRecognizer)
    backdropView
  end

#pragma mark - Picker View

  def numberOfComponentsInPickerView(pickerView)
    1
  end

  def pickerView(pickerView, numberOfRowsInComponent:component)
    return self.values.count
  end

  def pickerView(pickerView, titleForRow:row, forComponent:component)
    self.values.objectAtIndex(row)
  end

  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    puts "pickerView didSelectRow"
    self.setSelectedIndex(row)
  end

end