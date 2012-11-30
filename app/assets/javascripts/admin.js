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
  	oLanguage:       {
      sLengthMenu: "Show _MENU_ records per page",
      sSearch    : "Search all columns:"
    },
  	aoColumns: 			 (jQuery.map($('.datatable th'), function(n, i){
      return ($(n).hasClass('no_sort') ? {"bSortable": false} : {"bSortable": true});
    }))
	});

  function specialInputFilters(je){
    // TODO filter date_interval
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