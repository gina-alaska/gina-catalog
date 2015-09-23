# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "upload:start", "form", (e) ->
  $(this).find("input[type=submit]").attr("disabled", true)
  $(this).find('.progress').removeClass('hidden')
  $(this).find('.progress-bar').removeClass('progress-bar-danger')
  $(this).find('.progress-bar').removeClass('progress-bar-success')
  $(this).find('.progress-bar').width("0%")

$(document).on "upload:success", "form", (e) ->
  $(this).find('.progress-bar').html("Upload complete!")
  $(this).find('.progress-bar').removeClass('progress-bar-danger')
  $(this).find('.progress-bar').addClass('progress-bar-success')
  $(this).find('.progress-bar').width("100%")

$(document).on "upload:failure", "form", (e) ->
  switch e.originalEvent.detail.xhr.status
    when 413 then message = "File is too large"
    else message = e.originalEvent.detail.xhr.statusText

  $(this).find('.progress-bar').html("Upload error: #{message}")
  $(this).find('.progress-bar').removeClass('progress-bar-success')
  $(this).find('.progress-bar').addClass('progress-bar-danger')
  $(this).find('.progress-bar').width("100%")

$(document).on "upload:complete", "form", (e) ->
  if !$(this).find("input.uploading").length
    $(this).find("input[type=submit]").removeAttr("disabled").removeClass("disabled")
    # $(this).find('.progress').addClass('hidden')

$(document).on "upload:progress", "form", (e) ->
  detail = e.originalEvent.detail
  if detail.lengthComputable
    progress = parseInt(detail.loaded / detail.total * 100)
    $(this).find('.progress-bar').html("#{progress}% uploaded")
    $(this).find('.progress-bar').width("#{progress}%")
