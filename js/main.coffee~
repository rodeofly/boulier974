UID = 0
class Bille
  constructor : (@weight) ->
    @id = UID++    
    @html = ->  
      w= if @weight > 1 then "five" else "one"
      return "<div id='#{@id}' class='bille #{w} off' data-weight=#{@weight}></div>"

class Tige
  constructor : (@unit) ->
    @id = UID++
    @html = -> return """      
      <div id='#{@id}' class='tige' data-unit='#{@unit}'>
        <div class='billes'>
          <div class='unaire'>
              <div class='deactivated'></div>
              <div class='activated'  ></div>
          </div>
          
          <div class='quinaire'>
              <div class='activated'  ></div>
              <div class='deactivated'></div>  
          </div>
        </div>
        <div class="tpanel">
          <div class='unit'>#{Math.pow 10,@unit}</div> 
          <input class='unit' type='radio' name='unity' value='#{@unit}' >
        </div>
      </div>"""

class Boulier
  constructor : (@tiges=10) ->
    @id = UID++   
    @html = ->
      $boulier = $( "<div id='##{@id}' class='boulier' data-tiges='#{@tiges}'></div>" )
      for i in [0..@tiges-1]
        tige = new Tige(i)
        $boulier.append tige.html()               
        for j in [1..5]
          bille = new Bille(1)
          $boulier.find( "##{tige.id} .unaire .deactivated" ).append( bille.html() ) 
        for k in [1..2]
          bille = new Bille(5)
          $boulier.find( "##{tige.id} .quinaire .deactivated" ).append( bille.html() )
      return $("<div/>").append($boulier).html()

on_total = ->
  n = 0
  $( ".one.on, .five.on"  ).each ->
    w = parseFloat( $(this).attr "data-weight" )
    u = Math.pow( 10, parseInt( $(this).closest(".tige").attr "data-unit" ))
    n += w*u 
  [min, max] = [0, 0]
  $(".boulier").find(".tige").each ->
    d = parseInt($(this).attr( "data-unit" ), 10)
    min = d if (d < min)
    max = d if (d > max)
  $( "#x" ).html n.toFixed( Math.abs min )

$ ->
  $( "#toggle_value" ).on "click", -> $( "#x" ).toggle()
  $( "#toggle_orientation" ).on "click", -> $( ".boulier" ).toggleClass "horizontal"
  
  $( "#init" ).on "click", ->
    boulier = new Boulier(10)
    $( "#wrapper" ).empty().append boulier.html()
    $( "input[name='unity']" ).first().prop('checked', true)
  $( "#init" ).trigger "click"
  
  $( "body" ).on "click", "input[name='unity']", ->
    tige = parseInt( "#{$( this ).parent().parent().attr 'data-unit'}" )
    $( ".tige" ).each ->
        p = tige - parseInt( $( this ).attr "data-unit")
        v = Math.pow(10, p)
        $( this ).attr( "data-unit", p)
        $( this ).find( ".unit" ).html( v )
        on_total()
        
  $( "body" ).on "click", ".bille", ->
    tige_id = $( this ).closest( ".tige" ).attr "id"
    bille = $(this)
    if bille.hasClass "one"
      if bille.hasClass "off"
        target = $( "##{tige_id} .unaire .activated")
      else  
        target = $( "##{tige_id} .unaire .deactivated")
    else
      if bille.hasClass "off"
        target = $( "##{tige_id} .quinaire .activated")
      else  
        target = $( "##{tige_id} .quinaire .deactivated")
    target.append( $( this ).nextAll().andSelf().toggleClass( "on off" ) )
    on_total()
    

  
  
