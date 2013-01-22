include SugarCube::Adjust

class AppDelegate

  BASE_URL = "http://localhost:3000"

  attr_accessor :backend

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    init_restkit
    #debug_restkit
    login

    add_response_mapping(libro_mapping, "libro")
    add_response_mapping(libro_mapping, "libri")
    add_request_mapping(libro_mapping, "libro")
    add_route_set(Libro, "api/v1/libri", "api/v1/libri/:remote_id")

    add_response_mapping(cliente_mapping, "cliente")
    add_response_mapping(cliente_mapping, "clienti")
    add_request_mapping(cliente_mapping, "cliente")
    add_route_set(Cliente, "api/v1/clienti", "api/v1/clienti/:remote_id")

    add_response_mapping(appunto_mapping, "appunto")
    add_response_mapping(appunto_mapping, "appunti")
    add_request_mapping(appunto_mapping, "appunto")
    add_route_set(Appunto, "api/v1/appunti", "api/v1/appunti/:remote_id")

    add_response_mapping(riga_mapping, "riga")
    add_response_mapping(riga_mapping, "righe")

    add_request_mapping(inverse_appunto_mapping, "appunto")
    add_request_mapping(inverse_riga_mapping, "riga")

    add_route_set(Riga,
                  "api/v1/appunti/:remote_appunto_id/righe",
                  "api/v1/appunti/:remote_appunto_id/righe/:remote_id")



    AFNetworkActivityIndicatorManager.sharedManager.enabled = true

    if Device.ipad?
      storyboard = UIStoryboard.storyboardWithName("MainStoryboard_iPad", bundle:nil)
      @window.rootViewController = storyboard.instantiateInitialViewController
      splitViewController = self.window.rootViewController
      navigationController = splitViewController.viewControllers.lastObject
      splitViewController.delegate = navigationController.topViewController
    else
      #storyboard = UIStoryboard.storyboardWithName("MainStoryboard_iPhone", bundle:nil)
      storyboard = UIStoryboard.storyboardWithName("Example", bundle:nil)
      @window.rootViewController = storyboard.instantiateInitialViewController
    end

    @window.makeKeyAndVisible
    true
  end

  def window
    @window
  end

  def setWindow(window)
    @window = window
  end

  def init_restkit
    url = NSURL.URLWithString(BASE_URL)
    self.backend = RKObjectManager.managerWithBaseURL(url)
  end



  def debug_restkit
    RKLogInitialize()
    RKlcl_configure_by_name("RestKit/Network", RKLogLevelTrace)
    RKlcl_configure_by_name("RestKit/ObjectMapping", RKLogLevelTrace)
  end

  def login

    #server 
    #app_id = "36e1b9ed802dc7ee45e375bf318924dc3ae0f0f842c690611fde8336687960eb"
    #secret = "11ab577f8fabf2ac33bdd75e951fc6507ef7bc21ef993c2a77a1383bed438224"

    #paolotax
    app_id = "9aa427dcda89ebd5b3c9015dcd507242b70bac2a4d6e736589f6be35849474ff"
    secret = "a5d78f0c32ba25fcbc1a679e03b110724497684263c1f4d9f645444cbf80a832"

    data = {
      grant_type: 'password',
      client_id: app_id,
      client_secret: secret,
      username: "paolotax",
      password: "sisboccia"
    }

    AFMotion::Client.build_shared(BASE_URL) do
      header "Accept", "application/json"
      operation :json
    end
    
    AFMotion::Client.shared.post("oauth/token", data) do |result|
      if result.success?

        token = result.object['access_token']
        puts "#{token}"
        self.backend.HTTPClient.setDefaultHeader("Authorization", value: "Bearer #{token}")
      else
        puts result.error
      end
    end
  end

  def libro_mapping
    @libro_mapping ||= begin
      mapping = RKObjectMapping.mappingForClass(Libro)
      mapping.addAttributeMappingsFromDictionary(id: "remote_id",
                                                 titolo: "titolo",
                                                 sigla: "sigla",
                                                 prezzo_copertina: "prezzo_copertina", 
                                                 prezzo_consigliato: "prezzo_consigliato",
                                                 settore: "settore" 
                                                 )
    end
  end

  def cliente_mapping
    @cliente_mapping ||= begin
      mapping = RKObjectMapping.mappingForClass(Cliente)
      mapping.addAttributeMappingsFromDictionary(id: "remote_id",
                                                 titolo: "nome",
                                                 comune: "comune",
                                                 frazione: "frazione",
                                                 cliente_tipo: "cliente_tipo",
                                                 indirizzo: "indirizzo",
                                                 cap: "cap",
                                                 provincia: "provincia",
                                                 telefono: "telefono",
                                                 email: "email",
                                                 latitude: "latitude",
                                                 longitude: "longitude"
                                                 )
    end
  end

  def appunto_mapping
    @appunto_mapping ||= begin
      
      mapping = RKObjectMapping.mappingForClass(Appunto)
      mapping.addAttributeMappingsFromDictionary(id: "remote_id",
                                                 destinatario: "destinatario",
                                                 note: "note",
                                                 status: "status",
                                                 telefono: "telefono",
                                                 cliente_id: "cliente_id",
                                                 created_at: "created_at",
                                                 totale_copie: "totale_copie",
                                                 totale_importo: "totale_importo",
                                                 cliente_nome: "cliente_nome"
                                                 )
      mapping.addPropertyMapping(RKRelationshipMapping.relationshipMappingFromKeyPath("righe", 
                                    toKeyPath:"righe", withMapping:riga_mapping))
    end 
  end

  def riga_mapping
    @riga_mapping ||= begin
      mapping = RKObjectMapping.mappingForClass(Riga)
      mapping.addAttributeMappingsFromDictionary(id: "remote_id",
                                           libro_id: "libro_id",
                                         appunto_id: "remote_appunto_id",
                                             titolo: "titolo",
                                   prezzo_copertina: "prezzo_copertina",
                                    prezzo_unitario: "prezzo_unitario",
                                           quantita: "quantita",
                                             sconto: "sconto"
                                           )
    end
  end

  def inverse_riga_mapping
    @inverse_riga_mapping ||= begin
      mapping = RKObjectMapping.requestMapping
      mapping.addAttributeMappingsFromDictionary(
                                           libro_id: "libro_id",
                                   prezzo_copertina: "prezzo_copertina",
                                    prezzo_unitario: "prezzo_unitario",
                                           quantita: "quantita",
                                             sconto: "sconto")
    end
  end

  def inverse_appunto_mapping
    @inverse_appunto_mapping ||= begin
      mapping = RKObjectMapping.requestMapping
      mapping.addAttributeMappingsFromDictionary(destinatario: "destinatario",
                                                 note: "note",
                                                 status: "status",
                                                 telefono: "telefono",
                                                 cliente_id: "cliente_id")
    end
  end


  def add_response_mapping(mapping, path)
    successCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
    descriptor = RKResponseDescriptor.responseDescriptorWithMapping(mapping,
                                                               pathPattern: nil,
                                                               keyPath: path,
                                                               statusCodes: successCodes)
    backend.addResponseDescriptor(descriptor)
  end

  def add_request_mapping(mapping, path)
    request_descriptor = RKRequestDescriptor.requestDescriptorWithMapping(mapping.inverseMapping,
                                                                          objectClass: mapping.objectClass,
                                                                          rootKeyPath: path)
    backend.addRequestDescriptor(request_descriptor)
  end

  def add_route_set(klass, collection_path, resource_path)
    get_route = RKRoute.routeWithClass(klass, 
                                       pathPattern: resource_path,
                                       method: RKRequestMethodGET)
    put_route = RKRoute.routeWithClass(klass, 
                                       pathPattern: resource_path,
                                       method: RKRequestMethodPUT)
    delete_route = RKRoute.routeWithClass(klass, 
                                          pathPattern: resource_path,
                                          method: RKRequestMethodDELETE)
    post_route = RKRoute.routeWithClass(klass, 
                                        pathPattern: collection_path,
                                        method: RKRequestMethodPOST)
    backend.router.routeSet.addRoute(get_route)
    backend.router.routeSet.addRoute(put_route)
    backend.router.routeSet.addRoute(delete_route)
    backend.router.routeSet.addRoute(post_route)
  end

end
