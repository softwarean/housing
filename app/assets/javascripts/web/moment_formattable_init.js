$(function() {
  document.addEventListener('turbolinks:load', function() {
    var momentSpans = $('.moment-formattable');

    $.each(momentSpans, function(i, span) {
      var momentSpan = $(span);

      var utcDateTime = momentSpan.attr('data-utc');
      var outFormat = momentSpan.attr('data-out-format');

      var localDateTime = moment.utc(utcDateTime, 'YYYY-MM-DD HH:mm:ss').toDate();
      var localDateTime = moment(localDateTime).format(outFormat);

      momentSpan.html(localDateTime);
    });
  });
});
