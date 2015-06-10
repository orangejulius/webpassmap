map = null

initializeMap = () ->
  canvas = $('#map')

  if canvas.length
    geocoder = new google.maps.Geocoder()

    #geocode and set the starting point of the map
    geocoder.geocode address: 'San Francisco, CA', (results, status) ->
      mapOptions =
        zoom: 12
        center: results[0].geometry.location
        mapTypeId: google.maps.MapTypeId.ROADMAP


      #initialize the map and an infowindow object
      map = new google.maps.Map canvas.get(0), mapOptions

      infowindow = new google.maps.InfoWindow

      #hex falues of clolors for marker pins
      pinColors =
        red: 'FE7569'
        green: '34BA46'
        yellow: 'FFFF87'

      #url for the map pin with no color set
      chartUrlPrefix = "https://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|"

      #size and posiition settings for the map pins
      size = new google.maps.Size 21, 34
      startPoint = new google.maps.Point 0, 0
      endPoint = new google.maps.Point 10, 34

      #generate a MarkerImage object for each color
      pins = {}
      pins[color] = new google.maps.MarkerImage chartUrlPrefix+hex, size, startPoint, endPoint for color, hex of pinColors

      #generate one MarkerImage for the pin shadow
      shadowUrl = 'https://chart.apis.google.com/chart?chst=d_map_pin_shadow'
      pinShadow = new google.maps.MarkerImage("https://chart.apis.google.com/chart?chst=d_map_pin_shadow",
        new google.maps.Size(40, 37),
        new google.maps.Point(0, 0),
        new google.maps.Point(12, 35))

      #add each building to the map
      for building in buildings
        if building.latlon
          latlon = building.latlon.split(', ')
          glatlng = new google.maps.LatLng latlon[0], latlon[1]

          #set the pin color based on the building speeds
          if building.speeds == 'Commercial Service Only'
            markerImg = pins['yellow']
          else if building.speeds.indexOf('200 Mbps') != -1
            markerImg = pins['green']
          else
            markerImg = pins['red']

          #create the Marker object
          params =
            position: glatlng
            map: map
            title: building.name
            icon: markerImg
            shadow: pinShadow
          marker = new google.maps.Marker params
          #store the speeds as an attribute for use when opening the info window
          marker.speeds = building.speeds

          #add a listener to create an infowindow with address and speed info when clicked
          google.maps.event.addListener marker, "click", () ->
            content = '<b>' + this.title + '</b><br>'
            if this.speeds
              content += '<pre>' + this.speeds + '</pre>'
            infowindow.setContent content
            infowindow.open map, this

$(initializeMap)
