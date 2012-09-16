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

$(initializeMap)
