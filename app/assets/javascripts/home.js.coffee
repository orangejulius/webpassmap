map = null

initializeMap = () ->
  canvas = $('#map')

  if canvas.length
    geocoder = new google.maps.Geocoder()

    geocoder.geocode address: 'San Francisco, CA', (results, status) ->
      mapOptions =
        zoom: 12
        center: results[0].geometry.location
        mapTypeId: google.maps.MapTypeId.ROADMAP


      map = new google.maps.Map canvas.get(0), mapOptions

      #geocode each address and add to the map
      infowindow = new google.maps.InfoWindow

      pinColors =
        red: 'FE7569'
        green: '34BA46'
        yellow: 'FFFF87'

      chartUrlPrefix = "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|"

      size = new google.maps.Size 21, 34
      startPoint = new google.maps.Point 0, 0
      endPoint = new google.maps.Point 10, 34

      pins = {}

      pins[color] = new google.maps.MarkerImage chartUrlPrefix+hex, size, startPoint, endPoint for color, hex of pinColors

      shadowUrl = 'http://chart.apis.google.com/chart?chst=d_map_pin_shadow'

      pinShadow = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow",
        new google.maps.Size(40, 37),
        new google.maps.Point(0, 0),
        new google.maps.Point(12, 35))

      for building in buildings
        if building.latlon
          latlon = building.latlon.split(', ')
          glatlng = new google.maps.LatLng latlon[0], latlon[1]


          if building.speeds == 'Commercial Service Only'
            markerImg = pins['yellow']
          else if building.speeds.indexOf('200 Mbps') != -1
            markerImg = pins['green']
          else
            markerImg = pins['red']

          params =
            position: glatlng
            map: map
            title: building.name
            icon: markerImg
            shadow: pinShadow
          marker = new google.maps.Marker params
          marker.speeds = building.speeds

          google.maps.event.addListener marker, "click", () ->
            content = '<b>' + this.title + '</b><br>'
            if this.speeds
              content += '<pre>' + this.speeds + '</pre>'
            infowindow.setContent content
            infowindow.open map, this

$(initializeMap)
