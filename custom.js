document.querySelectorAll(".production_drivers a").forEach(function(externalLink){
  externalLink.addEventListener("click", function(e){
    if (confirm("You are being redirected to an external website.\nThe Kubernetes community does not validate external CSI drivers and they should be used at your own risk.") == true) {
      return true;
    } else {
      e.preventDefault(); // cancel the event
      return false;
    }
  });
});
