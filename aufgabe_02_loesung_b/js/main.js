$( document ).ready( function() {
  console.log( "Hallo los geht's!" );
  
  // Suche nach der Menu Taste
  $menu = $( '.menubutton' );
  $menu.click( function( e ) {
    console.log( '> click @ .menubutton' );
    // Schalte das Menu zwischen sichtbar und unsichtbar
    // hin und her
    $( '.menu' ).toggle();
  } );
} );
