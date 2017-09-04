$(document).ready(function(){
  
  $("#new-resolved-response").hide();
  $("#new-type-alert").hide();
  $('#type_alert').on('change', function() {
    if ( this.value == 'new')
    //.....................^.......
    {
      $("#new-type-alert").show();
      $("#new-resolved-response").hide();
    }
    else
    {
      $("#new-type-alert").hide();
      $("#new-resolved-response").show();
    }
  });
  
})