// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require jquery.ui.autocomplete
//= require jquery.ui.effect-highlight
//= require bootstrap
//= require jquery.typewatch
//= require_tree .


$(function(){
  $("a.submit-this").click(function(e){
    e.preventDefault();
    e.stopPropagation();
    $(this).closest("form").submit();
  });

  $(".submit-me").off();
  $(document).on("click", ".submit-me", function(e){
    var container = $(this).closest(".form-container");
    var inputs = $(":input", container).serialize();
    var $this = $(this);
    $.ajax({
      url: $(this).data("action"),
      data: inputs,
      dataType: "script",
      type: $(this).data("method")
    }).done(function(){
      $this.closest(".form-container").find("input:first").focus();
    });
  });

  var options_for_code = {
    callback: function(){
      var $this = $(this.el);
      var container = $this.closest(".form-container");
      $.ajax({
        url: $this.data("href"),
        data: $("input[type=text]", container).serialize(),
        dataType: "json",
        type: "get",
        success: function(data){
          if ( data.sku ) {
            $.each( data.sku, function(k, v){
              var input = $("input#item_" + k, container) ;
              input.val(v);
            });
          } else {
            $.clear_form(container, $this);
          }
          $("div#search-results").empty();
        }
      });
    },
    wait: 750,
    highlight: true,
    captureLength: 3
  }

  var options_for_name = {
    callback: function(){
      var $this = $(this.el);
      var container = $this.closest(".form-container");
      $.ajax({
        url: $this.data("href"),
        data: $("input[type=text]", container).serialize(),
        dataType: "json",
        type: "get",
        success: function(data){
          if ( data.skus ) {
            $.draw_result_search(data.skus);
          }
        }
      });
    },
    wait: 750,
    highlight: true,
    captureLength: 2
  }

  var options_default = {
    callback: function(){
      var $this = $(this.el);
      var container = $this.closest(".form-container");

      $.ajax({
        url: $this.data("href"),
        data: $("input", container).serialize(),
        dataType: "json",
        type: $this.data("method"),
        success: function(data){
          if ( !data.success ) {
            $("div.errors").html("<div class='alert alert-error'><button class='close' type='button' data-dismiss='alert'>&times;</button>" + data.message + "</div>");
          } else {
            $("div.errors").empty();
          }
        }
      });
    },
    wait: 750,
    highlight: true,
    captureLength: 0
  }

  $("#purchase_number, #purchase_comment").typeWatch( options_default );
  $("#item_code").typeWatch( options_for_code );
  $("#item_name").typeWatch( options_for_name );

  $("a.add_to_new_item").off();
  $(document).on("click", "a.add_to_new_item", function(e){
    var container = $("#new_item");
    var datas = $(this).closest("tr").data();
    $.each( datas, function(k, v){
      var input = $("input#item_" + k, container);
      input.val(v);
    });
    $("div#search-results").empty();
    $("input#item_unit_price").focus();
  });

  var cache = {}, lastXhr;
  $("#filter_customer").autocomplete({
    minLength: 3,
    source: function( request, response ) {
      var term = request.term;
      if ( term in cache ) {
        response( cache[ term ] );
        return;
      }
      lastXhr = $.getJSON( "/customers/find_customers", request, function( data, status, xhr ) {
        cache[ term ] = data;
        if ( xhr === lastXhr ) {
          response( data );
        }
      });
    },
    select: function(event, ui) {
      var form = $('<form>').attr({
          method: 'POST',
          action: '/sales'
       }).append(
          $('<input>').attr({
            type: 'hidden',
            name: 'customer_id',
            value: ui.item.id
          })
       ).appendTo("div.content").submit();
    }
  });

});

$.clear_form = function(form, element) {
  $(':input', form).not(':button, :submit, :reset').not(element).val('');
};

$.draw_result_search = function(skus) {
  var container = $("div#search-results");
  container.empty();
  if ( skus.length > 0 ) {
    var table = $("<table>");
    $.each(skus, function(i, sku){
      var tr = $("<tr>")
                .data('sku_id', sku.sku_id)
                .data('code', sku.code)
                .data('name', sku.name)
                .append("<td>" + sku.code + "</td>")
                .append("<td>" + sku.name + "</td>");
        if ( sku['unit_price'] ) {
          tr.append("<td>" + sku.unit_price + "</td>");
          tr.data('unit_price', sku.unit_price)
        }
        tr
          .append("<td>&nbsp;</td>")
          .append("<td colspan=2><a href='javascript:;' class='add_link add_to_new_item'>Agregar</a></td>")
          .appendTo(table);
    });
    container
      .append("<h3>Sugerencias</h3>")
      .append(table);
  }
};
