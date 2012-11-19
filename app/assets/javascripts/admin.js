//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap.pagination

/* Default class modification */
$.extend( $.fn.dataTableExt.oStdClasses, {
  sWrapper:  "dataTables_wrapper form-inline"
});	

$(function(){
	$('.datatable').dataTable({
		bProcessing:     true,
    bServerSide:     true,
    sAjaxSource:     $('.datatable').data('source'),
    sDom:            "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
  	sPaginationType: "bootstrap",
  	oLanguage:       {sLengthMenu: "_MENU_ records per page"},
  	aoColumns: 			 (jQuery.map($('.datatable th'), function(n, i){
	  	// return {"bSortable": false} for THs that has the no_sort class
      return ($(n).hasClass('no_sort') ? {"bSortable": false} : {"bSortable": true});
    }))
	});

});