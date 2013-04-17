class @FlashMessage
  constructor: (level, msg, target = '#flashes') ->
    @target = $(target)
    flash_message = "<div class=\"alert fade in alert-#{level}\"><a class=\"close\" data-dismiss=\"alert\" href=\"#\">X</a>#{msg}</div>"
    @target.append flash_message
      