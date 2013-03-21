# this just simply changes the add an asset to the portfolio form until the button is clicked, so it's cleaner for users
$(document).ready ->
  $("#add-asset-button").click ->
    $(".asset-form-container").css "display", "block"
