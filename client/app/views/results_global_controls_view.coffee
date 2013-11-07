View = require './../lib/view'
DeleteAllModel = require './../models/delete_all_model'

module.exports = class ResultsGlobalControlsView extends View

    el: '#results-global-controls'
    currentDoctype: ''
    templateModal: require('./templates/modal_confirm')

    events :
        'mouseover #delete-all' : 'convertButtonToDanger'
        'mouseout #delete-all' : 'convertButtonToClassic'
        'click #delete-all' : 'confirmDeleteAll'

    convertButtonToDanger: (event) ->
        jqObj = $(event.currentTarget)
        jqObj.addClass 'btn-danger'
        jqObj.children('span').text('Delete all ')

    convertButtonToClassic: (event) ->
        jqObj = $(event.currentTarget)
        jqObj.removeClass 'btn-danger'
        jqObj.children('span').empty()

    template: ->
        require './templates/results_global_controls'

    initialize : (opt) ->
        $(@el).undelegate '#delete-all', 'click'
        if opt.doctype?
            @currentDoctype = opt.doctype[0] || ''
        @render opt

    render: (opt) =>
        templateData = {}
        templateData['range'] = if opt.range then '(' + opt.range + ')' || ''
        templateData['doctype'] = if opt.doctype then opt.doctype[0] else ''

        super templateData

    confirmDeleteAll : (e) ->
        e.preventDefault()
        message = 'Are you sure ? This can\'t be undone, '
        message += 'and will erase definitly data from the database.'
        data =
            title: 'Confirmation required'
            body: message
            confirm: 'delete permanently'

        $("body").prepend @templateModal(data)
        $("#confirmation-dialog").modal()
        $("#confirmation-dialog").modal("show")
        $("#confirmation-dialog-confirm").unbind 'click'
        $("#confirmation-dialog-confirm").bind "click", =>
            @deleteAll()

    deleteAll: ->
        if @currentDoctype? and @currentDoctype isnt ''
            deleteAllModel = new DeleteAllModel()
            deleteAllModel.fetch
                data: $.param
                    doctype : @currentDoctype
            location.reload()
