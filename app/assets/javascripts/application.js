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
    captureLength: 1
  }

  var options_default = {
    callback: function(){
      var $this = $(this.el);
      var container = $this.closest(".form-container");

      $.ajax({
        url: $this.data("href"),
        data: $(":input", container).serialize(),
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

  $("#purchase_number, #purchase_comment, #sale_number, #sale_comment").typeWatch( options_default );
  $("#item_code").typeWatch( options_for_code );
  $("#item_name").typeWatch( options_for_name );

  /* quick fix to sale/purchase select kind change */
  $("#sale_kind, #purchase_kind").change(function(){
    var $this = $(this),
        container = $this.closest(".form-container");
    $.ajax({
      url: $this.data("href"),
      data: $(":input", container).serialize(),
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
  });

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

  $("input#sku_kind_product, input#sku_kind_material").change(function(){
    var $this = $(this),
        form = $this.closest("form");
    if ( $this.val() == "product" ) {
      $(".only-material", form).hide();
      $(".only-product", form).show();
    } else {
      $(".only-product", form).hide();
      $(".only-material", form).show();      
    }
  });

  $.datepicker.regional['es'] = {
    closeText: 'Cerrar',
    prevText: '&#x3c;Ant',
    nextText: 'Sig&#x3e;',
    currentText: 'Hoy',
    monthNames: ['Enero','Febrero','Marzo','Abril','Mayo','Junio',
    'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
    monthNamesShort: ['Ene','Feb','Mar','Abr','May','Jun',
    'Jul','Ago','Sep','Oct','Nov','Dic'],
    dayNames: ['Domingo','Lunes','Martes','Mi&eacute;rcoles','Jueves','Viernes','S&aacute;bado'],
    dayNamesShort: ['Dom','Lun','Mar','Mi&eacute;','Juv','Vie','S&aacute;b'],
    dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','S&aacute;'],
    weekHeader: 'Sm',
    dateFormat: 'dd/mm/yy',
    firstDay: 1,
    isRTL: false,
    showMonthAfterYear: false,
    yearSuffix: ''};
  $.datepicker.setDefaults($.datepicker.regional['es']);

  $('.date-pick').off();
  $(document).on("mouseenter", ".date-pick", function(e){
    if($(this).hasClass("date-pick")){
      $(this).prop("id", $(this).prop("id") + new Date().getTime() );
      $(this).datepicker({
        dateFormat: 'dd/mm/yy',
        changeMonth: true,
        changeYear: true
      });
    }
    $(this).removeClass("date-pick");
  });

  $('.time-pick').off();
  $(document).on("mouseenter", ".time-pick", function(e){
    if($(this).hasClass("time-pick")){
      $(this).prop("id", $(this).prop("id") + new Date().getTime() );
      $(this).datetimepicker({
        dateFormat: 'dd/mm/yy',
        changeMonth: true,
        changeYear: true,
        ampm: true,
        timeOnlyTitle: 'Solo tiempo',
        timeText: 'Tiempo',
        hourText: 'Hora',
        minuteText: 'Minuto',
        secondText: 'Segundos',
        currentText: 'Ahora',
        closeText: 'Cerrar',
        stepMinute: 15
      });
    }
    $(this).removeClass("time-pick");
  });

  /* quick fix to sale and purchase date calendar select */
  $("input[id^=sale_sale_date], input[id^=purchase_purchase_date]").datepicker({
    dateFormat: 'dd/mm/yy',
    changeMonth: true,
    changeYear: true,
    onSelect : function(){
      var $this = $(this),
          container = $this.closest(".form-container");
      $.ajax({
        url: $this.data("href"),
        data: $(":input", container).serialize(),
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
    }
  });

  $("#q_customer_id_in").tokenInput("/reports/tokenize_customers", {
      theme: "facebook",
      minChars: 3,
      hintText: "Escriba el código o nombre del cliente a agregar",
      noResultsText: "No se encontro ninguna coincidencia",
      searchingText: "Buscando...",
      preventDuplicates: true
  });
  $("#q_sku_id_in, #q_id_in").tokenInput("/reports/tokenize_skus", {
      theme: "facebook",
      minChars: 3,
      hintText: "Escriba el código o nombre del producto a agregar",
      noResultsText: "No se encontro ninguna coincidencia",
      searchingText: "Buscando...",
      preventDuplicates: true
  });
  $("#q_service_id_in").tokenInput("/reports/tokenize_services", {
      theme: "facebook",
      minChars: 3,
      hintText: "Escriba el código o nombre del servicio a agregar",
      noResultsText: "No se encontro ninguna coincidencia",
      searchingText: "Buscando...",
      preventDuplicates: true
  });
  $("a.reset-tokens").off();
  $(document).on("click", "a.reset-tokens", function(e){
    $(this).closest("div").find("#q_customer_id_in, #q_sku_id_in, #q_service_id_in, #q_id_in").tokenInput("clear");
  });

});

$.clear_form = function(form, element) {
  $(':input', form).not(':button, :submit, :reset').not(element).val('');
  $('input:first', form).focus();
};

$.draw_result_search = function(skus) {
  var container = $("div#search-results");
  container.empty();
  if ( skus.length > 0 ) {
    var table = $("<table>");
    $.each(skus, function(i, sku){
      var tr = $("<tr>")
                .data('itemable_id', sku.itemable_id)
                .data('itemable_type', sku.itemable_type)
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
