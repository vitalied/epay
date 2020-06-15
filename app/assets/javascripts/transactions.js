$(function() {
  $('.transaction-uuid').hover(
    function(e) {
      const uuid = $(e.target).data('uuid');

      if (!uuid) {
        return
      }

      const transactions = $(`.transaction-uuid[data-uuid='${uuid}']`);
      if (transactions.length > 1) {
        transactions.addClass('transaction-uuid-hover');
      }
    },
    function() {
      $('.transaction-uuid').removeClass('transaction-uuid-hover');
    }
  );
});
