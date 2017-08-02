$(document).ready(function() {
	
	$('td[colspan=2]').addClass('groupHeader');
	$('table').addClass('fluidSize mainTable');
	
	var toc = {};
	var tocContent = '<div id="tocTitle">Navigate to:</div><div class="totalControl"><a href="#" class="totalLink" data-show="true">[show all]</a><br><a href="#" class="totalLink" data-show="false">[hide all]</a></div>';
	var labelSwitch = {false: '[show]', true: '[hide]'};
	
	
	$('.groupHeader').each(function(i) {
		tocContent += '<a class="topNav" href="#" data-id="' + i + '">' + $(this).html() + '</a> &bull; ';
		$(this).attr('id', 'group-' + i).append(' <a href="#" class="groupToggle" data-id="' + i + '">' + labelSwitch.false + '</a><a href="#toc" class="navToTop">[back to the top]</a>');	
	});
	
	var groupMember;
	var groupNum = 0;
	$('.mainTable tr').each(function(i) {
		if ($(this).children('td').length === 1) {
			groupMember = 'group-' + groupNum + '-member';
			groupNum++;
		}	else $(this).addClass('dataRow ' + groupMember);
	});
	$('.dataRow').hide();
	tocContent = tocContent.slice(0, -7); // remove last &bull;
	
	$('body').prepend('<div id="toc" class="fluidSize">' + tocContent + '</div>');
	
	
	
	$(document).on('click', '.topNav', function(e) {
		e.preventDefault();
		var id = $(this).data('id');
		
		$('.group-' + id + '-member').show();
		$('html').scrollTop($('#group-' + id).offset().top);
		$('.groupToggle[data-id=' + id + ']').html(labelSwitch.true);
	});
	
	$(document).on('click', '.groupToggle', function(e) {
		e.preventDefault();
		var state = $('.group-' + $(this).data('id') + '-member').is(":visible");
		$('.group-' + $(this).data('id') + '-member').toggle();
		$(this).html(labelSwitch[!state]);	
		if (!state) $('html').scrollTop($(this).offset().top);
	});
	
	$(document).on('click', '.totalLink', function(e) {
		e.preventDefault();
		var state = $(this).data('show');
		$('.dataRow').toggle(state);
		$('.groupToggle').html(labelSwitch[state]);
	});
	
});