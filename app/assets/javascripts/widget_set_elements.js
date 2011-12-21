(function($) {


	$.fn.WidgetEditor = function(options) {
		// Settings to configure the jQuery lightBox plugin how you like
		options = jQuery.extend({
			// Configuration related to overlay
      urlForAdd: null,
      urlForSort: null,
      urlForEdit: null,
      urlForDelete: null,
      urlForSelectedList: null,
      seletableDivId: "widgets",
      selectedDivId: "widget_set_elements",
      seletableElementClass: "selectable_widget",
      selectedElementClass: "selected_widget",
      
      dialogWidth: 400,
      updateButtonText: "Save",
      deleteButtonText: "Remove",
      editButtonText: "Edit",
      closeButtonText: "Close",
      confirmtionDelete: "OK?", 
      msgFailedInConnection: "failed in connecting to server.",
      msgFailedInDeleting: "failed in deleting.",
      msgErrorCount: " errors occured.",
      msgNotExists: "failed in deleting.",
      idForErrorExplanation: "error_explanation",
      idForErrorCount: "error_count",
		},options);
    area = this;
    
  function _initialize(options) {
    var instance =  new WidgetEditor(options);
    _setHandlerToAddButtons();
//    _setHandlerToEditButtons();
    _addSelectedWidgets();
    
    return instance;
  }

  function _setHandlerToAddButtons() {
    $('#' + options.seletableDivId + ' input:button', $(area)).each(function() {
      $(this).click(function() {
        var widgetType = $('.widget_type', $(this).parent()).val();
        _addWidget(widgetType);
      })
    });
  }
  
  /*
   * 
  */
  function _addWidget(widgetType) {
    
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    
    $.ajax( {
      type: "POST",
      url: options.urlForAdd,
      dataType: 'json',
      data: {
        'authenticity_token': csrfToken,
        'widget_type': widgetType
      },
      success: function(data, dataType) {
        _addSelectedWidget(data);
        _openDialog(data.widget_set_element.id);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたwidgetを削除
        alert(that.msgFailedInConnection);
      }
      });
    
  }
  
  function _addSelectedWidget(data) {
    var selectedWidgets = $('#' + options.selectedDivId);
    var widgetElement = data.widget_set_element;
    var widget = data.widget;
    var topElem = $("<div class='selected_widget' id='widget_set_element_" + widgetElement.id + "'></div>").
                  appendTo(selectedWidgets);
    var titleElem = $("<div class='widget_title'></div>").appendTo(topElem);
    var h3 = $("<h3></h3>").appendTo(titleElem);
    $("<span>" + widget.title + "</span>").appendTo(h3);
    var actions = $("<div class='actions'></div>").appendTo(h3);
    $("<input type='button' value='" +   options.deleteButtonText + "' />"  ).
      appendTo(actions).
      click( function() {
        _deleteWidget(widgetElement.id);
        });
    $("<input type='button' value='" +   options.editButtonText + "' />"  ).
      appendTo(actions).
      click( function() {
        _openDialog(widgetElement.id);
        });
//      
    
  }

  function _updateSelectedWidget(data) {
    var selectedWidgets = $('#' + options.selectedDivId);
    var widgetElement = data.widget_set_element;
    var widget = data.widget;
    $('h3 span', $('#' + 'widget_set_element_' + widgetElement.id)).text(widget.title);
  }


  function _addSelectedWidgets() {
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    $.ajax( {
      type: "GET",
      url: options.urlForSelectedList,
      dataType: 'json',
      data: {
        'authenticity_token': csrfToken
      },
      success: function(data, dataType) {
        jQuery.each(data,function(){
          _addSelectedWidget(this);
         });
         _setOrdering();
      }
    });
  }

  
  function _setHandlerToEditButtons() {
    var c = 0;
    
    $('.' + options.selectedElementClass, $(area)).each(function() {
      var div = this;
      var button = $('input:button', $(div));
      var csrfToken = $('meta[name="csrf-token"]').attr('content');
      var id = $(this).attr('id');
      button.click(function() {
        _openDialog(id);
      });
    });
  }
  
  //
  //parameters
  // id => widget_set_element.id
  function _openDialog(id) {
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    $.ajax( {
      type: "GET",
      url: options.urlForEdit + '/' + id,
      dataType: 'html',
      data: {
        'authenticity_token': csrfToken,
        'id': id
      },
      success: function(data, dataType) {
        $(':first', $('#dialog')).remove();
        $(data).appendTo($('#dialog'));
        $('form').submit(function(){ return false; }); 
        var dialogObject = $('#dialog').dialog({
          autoOpen: true,
          width: options.dialogWidth,
          modal: false,
          title: _getTitleByElementId(id),
          close: function() {
            $(':first', $(this)).remove();
          },
          buttons: [
            {
              text : options.updateButtonText,
              click: function() {
                var csrfToken = $('meta[name="csrf-token"]').attr('content');
                $.ajax( {
                  type: "PUT",
                  url: $('form', $('#dialog')).attr('action'),
                  dataType: 'json',
                  data: $('form', $('#dialog')).serialize() + '&authenticity_token=' + csrfToken,
                  success: function(data) {
                     if(data.error) {
                       _addErrorExplanation(data.error);
                     }
                     else {
                       _updateSelectedWidget(data);
                       $('#dialog').dialog('close');
                     }
                  },
                  error: function(msg) {alert(msg + "error!")},
                  complete: function() {} 
                  });
              } // function
            },
            {
              text: options.closeButtonText,
              click: function() {
                $('#dialog').dialog('close');
              }
            }
            ]
        });
        
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたwidgetを削除
        alert(that.msgFailedInConnection);
      }
      });
      //$('#dialog').dialog('open');
    
  }

  //
  //parameters
  // id => widget_set_element.id
  function _deleteWidget(id) {
    if(!confirm(options.confirmtionDelete)) {
      return;
    }
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    $.ajax( {
      type: "DELETE",
      url: options.urlForDelete + '/' + id,
      dataType: 'json',
      data: {
        'authenticity_token': csrfToken,
      },
      success: function(data, dataType) {
        var selectedWidgets = $('#' + options.selectedDivId);
        var widgetElement = data.widget_set_element;
        var widget = data.widget;
        $('#' + 'widget_set_element_' + widgetElement.id).remove();
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたwidgetを削除
        alert(options.msgFailedInConnection);
      }
      });
      //$('#dialog').dialog('open');
  }
  

  function _addErrorExplanationInMain(error) {
    $('#main > #error_explanation').remove();
    
    var div = $('<div id="error_explanation"></div>').appendTo($('#main'));
    
    div.css("display", "block");
    var ul = $('<ul></ul>').appendTo(div);
    jQuery.each(error,function(){
      $('<li>' + this + '</li>').appendTo(ul);
     });
    
  }

  
  function _addErrorExplanation(error) {
    $("*", $('#error_explanation')).remove();
    var div = $('#error_explanation');
    
    div.css("display", "block");
    var ul = $('<ul></ul>').appendTo(div);
    jQuery.each(error,function(){
      $('<li>' + this + '</li>').appendTo(ul);
     });
    
  }
  
  function _getTitleByElementId(id) {
    var topElem = $('#widget_set_element_' + id);
    if(!topElem) return '';
    var elem = $('h3 span', topElem);
    if(!elem) return '';
    return elem.text();
  }
  
  function _setOrdering() {
    $('#' + options.selectedDivId).sortable({
      update: function(event, ui) {
        _updateOrderingOnDB(this);
    }});
  }
  
  // 選択済み widget エリアでの並び変え操作をサーバーへ反映させる
  _updateOrderingOnDB  = function(selectedWidgets) {
    widgets = [];
    var matches;
    $('.selected_widget', $(selectedWidgets)).each(function() { 
        matches = $(this).attr('id').match(/^widget_set_element_([0-9]+)+$/);
        if(matches) {
          widgets.push(matches[1]);
        }
      }) ;
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    $.ajax( {
      type: "PUT",
      url: options.urlForSort,
      dataType: 'json',
      data: {
        'authenticity_token': csrfToken,
        order: widgets.join(',')
      },
      success: function(data, dataType) {
        if(data.status == 'OK') {
          
        }
        else {
          if(data.error) {
            _addErrorExplanationInMain(data.error);
          }
        }
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // エラー時. 挿入されたwidgetを削除
        alert(options.msgFailedInConnection);
      }
      });
      //$('#dialog').dialog('open');
    
  };

  function _addButtonClicked() {
    
  }
  


  WidgetEditor = function(options) {
    var options = options;
    function hoge() {
      alert("gofe");
    }
    
  };
  
  var fn = WidgetEditor.prototype;
  
  fn.boke = function() {
  };
  
  return _initialize(options);
  

}})(jQuery); // Call and execute the function immediately passing the jQuery object