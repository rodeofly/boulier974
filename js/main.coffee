$ ->
  for i in [5..-5]
    unit = Math.pow 10, i
    html = """
      <div id='#{i}' class='tige'>
        <div class='unaire'>
          <div class='deactivated'></div>
          <div class='activated'></div>
        </div>
        <div class='quinaire'>
          <div class='activated'></div>
          <div class='deactivated'></div>
        </div><div class='unit'>#{unit}</div>
      </div>"""
    $( "#boulier" ).append html
    
    for j in [1..5]
      $( "##{i} .unaire .deactivated" ).append "<div class='bille one off' data-unit=#{unit}></div>"
      
    for j in [1..2]
      $( "##{i} .quinaire .deactivated" ).append "<div class='bille five off' data-unit=#{unit}></div>"
  
  $( "#HV" ).on "click", ->
    $( "#boulier, .unit, .tige, .unaire, .quinaire, .activated, .deactivated, .bille" ).toggleClass "horizontal"
  
  $( "body" ).on "click", ".bille", ->
    tige_id = $( this ).closest( ".tige" ).attr "id"
    bille = $(this)
    if bille.hasClass "one"
      if bille.hasClass "off"
        console.log "woota#0"
        target = $( "##{tige_id} .unaire .activated")
      else  
        console.log "woota#1"
        target = $( "##{tige_id} .unaire .deactivated")
    else
      if bille.hasClass "off"
        console.log "woota#2"
        target = $( "##{tige_id} .quinaire .activated")
      else  
        console.log "woota#3"
        target = $( "##{tige_id} .quinaire .deactivated")
    target.append( $( this ).nextAll().andSelf().toggleClass( "on off" ) )
    n = 0
    $( ".one.on"  ).each -> n += parseFloat( $(this).attr "data-unit" ) 
    $( ".five.on" ).each -> n += parseFloat( $(this).attr "data-unit" ) * 5
    $( "#nombre" ).html n 
    

  
  
