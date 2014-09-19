function f_page_slide( e ) {
  console.log( '> complete @ $seite.load' );
  // Seite ist geladen worden, starte Slide Animation
  $seite.removeClass( 'out_right' );
  $( '.page#haupt' ).addClass( 'out_left' );
  $( '.menubutton#back' ).show();
}

function f_page_slide_back( e ) {
  console.log( '> complete @ $seite.load' );
  // Seite ist geladen worden, starte Slide Animation
  $seite.removeClass( 'out_right' );
  $( '.page#haupt' ).addClass( 'out_left' );
  $( '.menubutton#back' ).show();
}

function f_click_liste( e ) {
  console.log( '> click @ li element' );
  console.log( 'parameter e:' + e );
  
  // Erzeuge neue 'page' Section
  $seite = $( '<section class="page out_right" id="detail"></section>' );
  $( '.page#haupt' ).after( $seite );
  
  // Lade Detail-Seite, slide herein
  $seite.load( 'detail.html #detail_inhalt', f_page_slide );
}


$( document ).ready( function() {
  // Dokument ist fertig geladen
  console.log( "Hallo los geht's!" );
  
  // Binde KlickHandler an die Liste
  var $list, $titlebar;
  $list = $( '.list' );
  $list.on( 'click', 'li', f_click_liste );
  
  // Binde KlickHandler an die Menutaste
  $titlebar = $( '.titlebar' );
  $titlebar.on( 'click', '.menubutton#back', f_page_slide_back );
  
} );
