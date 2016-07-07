UID = 0

# pretty print for tri lli ons ! 
magnify = ( str ) ->
  str = str.split('.')
  str[0] = str[0].replace(/(\d)(?=(\d{3})+$)/g, '$1 ') if (str[0].length >= 5) 
  str[1] = str[1].replace(/(\d{3})/g, '$1 ') if (str[1] and str[1].length >= 5)
  return str.join('.')

on_total = (id) ->
  n = 0
  $( "##{id} .one.on, .five.on"  ).each ->
    w = parseFloat( $(this).attr "data-weight" )
    u = Math.pow( 10, parseInt( $(this).closest(".tige").attr "data-unit" ))
    n += w*u  
  [min, max] = [0, 0]
  $("##{id}").find(".tige").each ->
    d = parseInt($(this).attr( "data-unit" ), 10)
    min = d if (d < min)
    max = d if (d > max)  
  $( "##{id} #x" ).html( magnify( n.toFixed( Math.abs min )  ))
    
class Bille
  constructor : (@weight) ->
    @id = UID++    
    @html = ->  
      w = if @weight > 1 then "five" else "one"
      return "<div id='#{@id}' class='bille #{w} off' data-weight=#{@weight}></div>"

class Tige
  constructor : (@unit) ->
    @id = UID++       
    @html = -> return """      
      <div id='#{@id}' class='tige' data-unit='#{@unit}'>
        <div class='billes'>
          <div class='unaire'><div class='deactivated'></div><div class='activated'  ></div></div>  
          <div class='quinaire'><div class='activated'  ></div><div class='deactivated'></div></div>
        </div>
        <div class="tpanel">
          <input type='radio' name='unity' value='#{@unit}' >
          <div class='unit'> #{magnify( Math.pow(10, @unit).toString() )}</div> 
        </div>
      </div>"""

class Boulier
  constructor : (@tiges=10, $container) ->
    @id = UID++  
    @html = ->
      $boulier = $( """
        <div id='#{@id}' class='boulier' data-tiges='#{@tiges}'>
          <div id='panel'>
            <input type='range'  min='1' max='20' value='#{@tiges}' name='tselect' class='tselect'/>
            <button class='init' data-id='#{@id}'>&#10026;</button>
            <button class='toggle_orientation'    data-id='#{@id}'>&#8635; </button>
            <button class='toggle_value'          data-id='#{@id}'>&#9746; </button>
            <span id="x">0</span>
        </div></div>""" )
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
    if $container.length
      $container.empty().append @html()
      $( "input[name='unity']" ).first().prop('checked', true)

$ ->
  # Top Panel
  $( "body" ).on "click", ".init", -> 
    id = $( this ).attr "data-id"
    tiges = parseInt $( "##{id}" ).find(".tige").length
    boulier = new Boulier(tiges, $( "#wrappers" ))

  $( "body" ).on "click", ".toggle_value", ->
    id = $( this ).attr "data-id"
    $( "##{id} #x" ).toggle()

  $( "body" ).on "click", ".toggle_orientation" , ->
    id = $( this ).attr "data-id"
    $( "##{id}" ).toggleClass "horizontal"
  
  $( "body" ).on "click", "input[name='unity']", ->
    id = $( this ).closest(".boulier").attr( "id" )
    tige = parseInt( "#{$( this ).parent().parent().attr 'data-unit'}" )
    $( "##{id} .tige" ).each ->
        p = tige - parseInt( $( this ).attr "data-unit")
        v = Math.pow(10, p)
        $( this ).attr( "data-unit", p)
        $( this ).find( ".unit" ).html( magnify v.toString() )
        on_total(id)
  
  # Boulier      
  $( "body" ).on "click", ".bille", ->
    boulier_id = $( this ).closest( ".boulier" ).attr "id"
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
    on_total(boulier_id)
  
  $( "body" ).on "change", ".tselect", ->
    v = $(this).val()
    id = $( this ).closest(".boulier").attr( "id" )
    new Boulier(parseInt(v), $( "#wrappers" ))
    
  # Auto Start ! 
  new Boulier(5, $( "#wrappers" ))
  
