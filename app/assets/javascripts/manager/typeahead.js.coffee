class @TypeAheadField
  # @name: name for this typeahead
  # @display_field: field to show in the popup
  # @url: url to use to query the remote end for data
  #       example: '/users.json?query=%QUERY'
  # @opts: {
  #   display_key: 'value'
  #   datum_tokenizer: function(d) { Bloodhound.tokenizers.whitespace(d[@display_field])}
  #   query_tokenizer: Bloodhound.tokenizers.whitespace
  #   limit: 10
  # }
  constructor: (@el, @opts = {}) ->
    @url = $(el).data('query')
    @name = $(el).data('name')

    default_tokenizer = (d) ->
      Bloodhound.tokenizers.whitespace(d[@display_field])

    @bloodhound = new Bloodhound({
      datumTokenizer: @opts.datum_tokenizer || default_tokenizer
      queryTokenizer: @opts.query_tokenizer || Bloodhound.tokenizers.whitespace
      limit: @opts.limit || 10
      remote: { url: @url }
    })
    @bloodhound.initialize()

    typeahead_opts = {
      name: @name,
      source: @bloodhound.ttAdapter(),
      displayKey: @opts.display_key || 'value'
    }
    if @opts.templates?
      typeahead_opts.templates = @opts.templates

    $(@el).typeahead(null,typeahead_opts)

  on: (event, handler) ->
    $(@el).on event, handler
