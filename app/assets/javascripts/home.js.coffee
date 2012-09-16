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
      for building in buildings
        if building.latlon
          latlon = building.latlon.split(', ')
          glatlng = new google.maps.LatLng latlon[0], latlon[1]

          params =
            position: glatlng
            map: map
            title: building.name
          marker = new google.maps.Marker params
          marker.speeds = building.speeds

          google.maps.event.addListener marker, "click", () ->
            content = '<b>' + this.title + '</b><br>'
            content += '<pre>' + marker.speeds + '</pre>'
            infowindow.setContent content
            infowindow.open map, this

$(initializeMap)
