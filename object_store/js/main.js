// Allgemeine Funktionen

function schreibe_in_liste( in_elem, in_index ) {
  console.log( '> schreibe_in_liste - ' + in_elem );
  console.log( '-- in_elem keys:' + Object.keys( in_elem ) );
  
  var objekt, $liste, $zeile;
  objekt = JSON.parse( in_elem.obj_json );
  
  $liste = $( 'ul.list' );
  
  $zeile = $( '<li></li>' );
  $zeile.html( objekt.inhalt );
  $liste.prepend( $zeile );
}

// ---------------------------------------------------
// EH -- Event Handler
function eh_text_senden( in_event ) {
  console.log( '> eh_text_senden' );
  
  var $textfeld, inhalt,
        mein_obj, mein_obj_json, post_obj;
  $textfeld = $( 'input#content' );
  inhalt = $textfeld[ 0 ].value;
  
  console.log( 'textfeld enthält:' + inhalt );
  
  // Mein zu speicherndes Objekt konstruieren
  mein_obj = { inhalt: inhalt };
  console.log( 'mein_obj:' + mein_obj );
  mein_obj_json = JSON.stringify( mein_obj );
  console.log( 'JSON von mein_obj:' + mein_obj_json );
  
  // Einwickelobjekt für einen Post konstruieren
  post_obj = { objekt: {
        app_ident: 'magtest',
        obj_json: mein_obj_json
  } };
  $.post( 'http://projekte.alma.zhdk.ch/objekte', post_obj );
}

function eh_text_laden( in_event ) {
  console.log( '> eh_text_laden' );
  
  $.get( 'http://projekte.alma.zhdk.ch/objekte.json?app_ident=magtest', eh_text_verarbeiten );
}

function eh_text_verarbeiten( in_data ) {
  console.log( '> eh_text_verarbeiten - in_data:' + in_data );
  
  var $liste;
  $liste = $( 'ul.list' );
  $liste.html( '' );
  
  in_data.forEach( schreibe_in_liste );
}


// ---------------------------------------------------
// Was soll bei Dokument Ready ausgeführt werden
$( document ).ready( function() {
  console.log( "Hallo los geht's!" );
  
  var $taste;
  $taste = $( '#senden' );
  $taste.on( 'click', eh_text_senden );
  
  $taste = $( '#laden' );
  $taste.on( 'click', eh_text_laden );
  
} );
