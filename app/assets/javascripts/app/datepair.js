
Date.prototype.addHours = function(h) {    
   this.setTime(this.getTime() + (h*60*60*1000)); 
   return this;
}

$(function() {

  $('.datepair input.date').each(function(){
    var $this = $(this);
    $this.datepicker({ 'dateFormat': 'yy-mm-dd' });

    // I am really really screwing the plugin =)
    if (this.id == 'event_start_at_date') {
      $this.on('changeDate change', function(){
        $('#event_end_at_date').val( this.value )
      });
    }

  });

  $('.datepair input.time').each(function() {
    var $this = $(this);
    var opts = { 'showDuration': true, 'timeFormat': 'g:ia', 'scrollDefaultNow': true };

    // I am really really screwing the plugin =)
    if (this.id == 'event_start_at') {
      $this.on('change', function(){
        var h = parseInt( this.value.split(":")[0], 10)
        var m = this.value.split(":")[1].substr(0,2)
        var is_pm = window.event_start_at.value.indexOf('pm') > -1
        //console.log('was',h,m,is_pm);
        if( h == 11 ){
          is_pm = !is_pm
        }
        if( h == 12){
          h = 1
          if( is_pm )is_pm
        } else {
          h += 1
        }
        $('#event_end_at').val( h+':'+m+( is_pm ? 'pm':'am') )
      });
    }

    $this.timepicker(opts);
  });

  // $('.datepair').each(initDatepair);

  function initDatepair()
  {
    var container = $(this);

    var startDateInput = container.find('input.start.date');
    var endDateInput = container.find('input.end.date');
    var dateDelta = 0;

    if (startDateInput.length && endDateInput.length) {
      var startDate = new Date(startDateInput.val());
      var endDate =  new Date(endDateInput.val());

      dateDelta = endDate.getTime() - startDate.getTime();

      container.data('dateDelta', dateDelta);
    }

    var startTimeInput = container.find('input.start.time');
    var endTimeInput = container.find('input.end.time');

    if (startTimeInput.length && endTimeInput.length) {
      var startInt = startTimeInput.timepicker('getSecondsFromMidnight');
      var endInt = endTimeInput.timepicker('getSecondsFromMidnight');

      container.data('timeDelta', endInt - startInt);

      if (dateDelta < 86400000) {
        endTimeInput.timepicker('option', 'minTime', startInt);
      }
    }
  }

  function doDatepair() {
    var target = $(this);
    if (target.val() == '') {
      return;
    }
    
    var container = target.closest('.datepair');

    if (target.hasClass('date')) {
      //updateDatePair(target, container);

    } else if (target.hasClass('time')) {
      //this make some visual update and constraints.. updateTimePair(target, container);
    }
  }

  function updateDatePair(target, container)
  {
    var start = container.find('input.start.date');
    var end = container.find('input.end.date');

    if (!start.length || !end.length) {
      return;
    }

    var startDate = new Date(start.val());
    var endDate =  new Date(end.val());

    var oldDelta = container.data('dateDelta');

    if (oldDelta && target.hasClass('start')) {
      var newEnd = new Date(startDate.getTime()+oldDelta);
      end.val(newEnd.format('yy-mm-dd'));
      end.datepicker('update');
      return;

    } else {
      var newDelta = endDate.getTime() - startDate.getTime();

      if (newDelta < 0) {
        newDelta = 0;

        if (target.hasClass('start')) {
          end.val(startDate.format('yy-mm-dd'));
          end.datepicker('update');
        } else if (target.hasClass('end')) {
          start.val(endDate.format('yy-mm-dd'));
          start.datepicker('update');
        }
      }

      if (newDelta < 86400000) {
        var startTimeVal = container.find('input.start.time').val();

        if (startTimeVal) {
          container.find('input.end.time').timepicker('option', {'minTime': startTimeVal});
        }
      } else {
        container.find('input.end.time').timepicker('option', {'minTime': null});
      }

      container.data('dateDelta', newDelta);
    }
  }

  function updateTimePair(target, container)
  {
    var start = container.find('input.start.time');
    var end = container.find('input.end.time');

    if (!start.length || !end.length) {
      return;
    }

    var startInt = start.timepicker('getSecondsFromMidnight');
    var endInt = end.timepicker('getSecondsFromMidnight');

    var oldDelta = container.data('timeDelta');
    var dateDelta = container.data('dateDelta');

    if (target.hasClass('start') && (!dateDelta || dateDelta < 86400000)) {
      end.timepicker('option', 'minTime', startInt);
    }

    var endDateAdvance = 0;
    var newDelta;

    if (oldDelta && target.hasClass('start')) {
      // lock the duration and advance the end time

      var newEnd = (startInt+oldDelta)%86400;

      if (newEnd < 0) {
        newEnd += 86400;
      }

      end.timepicker('setTime', newEnd);
      newDelta = newEnd - startInt;
    } else if (startInt !== null && endInt !== null) {
      newDelta = endInt - startInt;
    } else {
      return;
    }

    container.data('timeDelta', newDelta);

    if (newDelta < 0 && (!oldDelta || oldDelta > 0)) {
      // overnight time span. advance the end date 1 day
      var endDateAdvance = 86400000;

    } else if (newDelta > 0 && oldDelta < 0) {
      // switching from overnight to same-day time span. decrease the end date 1 day
      var endDateAdvance = -86400000;
    }

    var startInput = container.find('.start.date');
    var endInput = container.find('.end.date');

    if (startInput.val() && !endInput.val()) {
      endInput.val(startInput.val());
      endInput.datepicker('update');
      dateDelta = 0;
      container.data('dateDelta', 0);
    }

    if (endDateAdvance != 0) {
      if (dateDelta || dateDelta === 0) {
        var endDate =  new Date(endInput.val());
        var newEnd = new Date(endDate.getTime() + endDateAdvance);
        endInput.val(newEnd.format('yy-mm-dd'));
        endInput.datepicker('update');
        container.data('dateDelta', dateDelta + endDateAdvance);
      }
    }
  }
});

// Simulates PHP's date function
Date.prototype.format=function(format){var returnStr='';var replace=Date.replaceChars;for(var i=0;i<format.length;i++){var curChar=format.charAt(i);if(replace[curChar]){returnStr+=replace[curChar].call(this);}else{returnStr+=curChar;}}return returnStr;};Date.replaceChars={shortMonths:['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],longMonths:['January','February','March','April','May','June','July','August','September','October','November','December'],shortDays:['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],longDays:['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],d:function(){return(this.getDate()<10?'0':'')+this.getDate();},D:function(){return Date.replaceChars.shortDays[this.getDay()];},j:function(){return this.getDate();},l:function(){return Date.replaceChars.longDays[this.getDay()];},N:function(){return this.getDay()+1;},S:function(){return(this.getDate()%10==1&&this.getDate()!=11?'st':(this.getDate()%10==2&&this.getDate()!=12?'nd':(this.getDate()%10==3&&this.getDate()!=13?'rd':'th')));},w:function(){return this.getDay();},z:function(){return"Not Yet Supported";},W:function(){return"Not Yet Supported";},F:function(){return Date.replaceChars.longMonths[this.getMonth()];},m:function(){return(this.getMonth()<9?'0':'')+(this.getMonth()+1);},M:function(){return Date.replaceChars.shortMonths[this.getMonth()];},n:function(){return this.getMonth()+1;},t:function(){return"Not Yet Supported";},L:function(){return(((this.getFullYear()%4==0)&&(this.getFullYear()%100!=0))||(this.getFullYear()%400==0))?'1':'0';},o:function(){return"Not Supported";},Y:function(){return this.getFullYear();},y:function(){return(''+this.getFullYear()).substr(2);},a:function(){return this.getHours()<12?'am':'pm';},A:function(){return this.getHours()<12?'AM':'PM';},B:function(){return"Not Yet Supported";},g:function(){return this.getHours()%12||12;},G:function(){return this.getHours();},h:function(){return((this.getHours()%12||12)<10?'0':'')+(this.getHours()%12||12);},H:function(){return(this.getHours()<10?'0':'')+this.getHours();},i:function(){return(this.getMinutes()<10?'0':'')+this.getMinutes();},s:function(){return(this.getSeconds()<10?'0':'')+this.getSeconds();},e:function(){return"Not Yet Supported";},I:function(){return"Not Supported";},O:function(){return(-this.getTimezoneOffset()<0?'-':'+')+(Math.abs(this.getTimezoneOffset()/60)<10?'0':'')+(Math.abs(this.getTimezoneOffset()/60))+'00';},P:function(){return(-this.getTimezoneOffset()<0?'-':'+')+(Math.abs(this.getTimezoneOffset()/60)<10?'0':'')+(Math.abs(this.getTimezoneOffset()/60))+':'+(Math.abs(this.getTimezoneOffset()%60)<10?'0':'')+(Math.abs(this.getTimezoneOffset()%60));},T:function(){var m=this.getMonth();this.setMonth(0);var result=this.toTimeString().replace(/^.+ \(?([^\)]+)\)?$/,'$1');this.setMonth(m);return result;},Z:function(){return-this.getTimezoneOffset()*60;},c:function(){return this.format("Y-m-d")+"T"+this.format("H:i:sP");},r:function(){return this.toString();},U:function(){return this.getTime()/1000;}};