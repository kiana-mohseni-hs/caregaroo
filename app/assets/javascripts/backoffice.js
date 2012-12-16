//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap.pagination

/* Default class modification */
$.extend( $.fn.dataTableExt.oStdClasses, {
  sWrapper:  "dataTables_wrapper form-inline"
});	

$(function(){

	var oTable = $('.datatable').dataTable({
		bProcessing:     true,
    bServerSide:     true,
    sAjaxSource:     $('.datatable').data('source'),
    sDom:            "<'row-fluid'<'span6'l>>rt<'row-fluid'<'span6'i><'span6'p>>",
    sPaginationType: "bootstrap",
    iDisplayLength:  100,
  	oLanguage:       {
      sLengthMenu: "Show _MENU_ records per page",
      sSearch    : "Search all columns:"
    },
    aoColumns:       (jQuery.map($('.datatable th'), function(n, i){
      var c  = {},
          el = $(n);

      c.bSortable = el.hasClass('no_sort') ? false : true;
      c.bVisible  = el.hasClass('no_visible') ? false : true;
      return c;
    }))
	});

  function specialInputFilters(je){
    // those guys come in pairs, this may have been triggered by either the one on right or left
    if( je.data('filterType') == 'date_interval' ){
      var other = je.siblings('[type=date]')

      var left = je.data('left') ? je : other
      var right = ( left === je ) ? other : je
      //console.log(left.val(), '<>', right.val())
      //console.log('')
      return left.val()+'..'+right.val()
    }
    return false;
  }

  function triggerTableUpdate(){
    //alert(this.value)
    var jthis = $(this)
    var value = specialInputFilters(jthis) || this.value
     /* Filter on the column (the index) of this element */
    oTable.fnFilter( value , jthis.data('index'), false );
  }

  $('.filters input, .filters select').bind('keyup change input', triggerTableUpdate );

});