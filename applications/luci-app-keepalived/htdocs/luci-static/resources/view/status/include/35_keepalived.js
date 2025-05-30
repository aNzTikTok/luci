'use strict';
'require baseclass';
'require uci';
'require rpc';

const callKeepalivedStatus = rpc.declare({
	object: 'keepalived',
	method: 'dump',
	expect: {  },
});

return baseclass.extend({
	title: _('Keepalived Instances'),

	load: function() {
		return Promise.all([
			callKeepalivedStatus(),
			uci.load('keepalived'),
		]);
	},

	render: function(data) {
		var targets = (data[0].status) ? data[0].status : [];
		var instances = uci.sections('keepalived', 'vrrp_instance');

		var table =
			E('table', { 'class': 'table lases' }, [
				E('tr', { 'class': 'tr table-titles' }, [
					E('th', { 'class': 'th' }, _('Name')),
					E('th', { 'class': 'th' }, _('Interface')),
					E('th', { 'class': 'th' }, _('Active State')),
					E('th', { 'class': 'th' }, _('Initial State')),
					E('th', { 'class': 'th' }, _('Probes Sent')),
					E('th', { 'class': 'th' }, _('Probes Received')),
					E('th', { 'class': 'th' }, _('Last Transition')),
					E([])
				])
			]);

		cbi_update_table(table,
			targets.map(function(target) {
				var state;
				var state_initial;
				var instance_state = target.data.state;

				if (instance_state === 2) {
					state = 'MASTER';
				} else if (instance_state === 1) {
					state = 'BACKUP';
				} else if (instance_state === 0) {
					state = 'INIT';
				} else if (instance_state === 3) {
					state = 'FAULT';
				} else {
					state = 'UNKNOWN';
				}

				if (instances != '') {
					for (var i = 0; i < instances.length; i++) {
						if (instances[i]['name'] == target.data.iname) {
							state = state;
							state_initial = instances[i]['state'];
							break;
						}
					}
				}
				return  [ 
					target.data.iname,
					target.data.ifp_ifname,
					state,
					state_initial,
					target.stats.advert_sent,
					target.stats.advert_rcvd,
					new Date(target.data.last_transition * 1000)
				];	
			}, this), E('em', _('There are no active instances')));
		

		return E([
			table
		]);
	},
});
