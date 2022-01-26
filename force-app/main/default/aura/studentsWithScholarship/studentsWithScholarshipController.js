({
	init : function (cmp, event, helper) {
		helper.setColumns(cmp);
		helper.getStudents(cmp, event, helper)
	},

	updateTable : function(cmp, event, helper) {
		helper.getStudents(cmp, event, helper)
	}
});