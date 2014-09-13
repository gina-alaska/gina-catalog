# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  console.log 'foo'
  
  user_bloodhound = new Bloodhound({
    datumTokenizer: (d) ->
      console.log d
      tokens = Bloodhound.tokenizers.whitespace(d.name)
      tokens.push(d.email)
      tokens

    queryTokenizer: Bloodhound.tokenizers.whitespace

    limit: 10

    remote: { url: '/manager/users/autocomplete.json?query=%QUERY' }
  })
  user_bloodhound.initialize()
  
  $('[data-behavior="autocomplete-user"]').typeahead(null, {
    name: 'user',
    displayKey: 'name',
    source: user_bloodhound.ttAdapter(),
    templates: {
      suggestion: Handlebars.compile('<p>{{name}} &lt;{{email}}&gt;</p>')
    }
  })