({
	getStudents : function (cmp, event, helper) {
		let loadData = cmp.get("c.getStudentsWithScholarship");

		loadData.setParams({
			"limitList" : cmp.get("v.limit")
		});

		loadData.setCallback(this, function (response) {
			cmp.set("v.students", response.getReturnValue());
		});

		$A.enqueueAction(loadData);
	},

	setColumns : function (cmp) {
		cmp.set('v.columns', [
			{label: 'Student Name', fieldName: 'Name', Type: 'text'},
			{label: 'Year of Study', fieldName: 'Year_of_Study__c', Type: 'text'},
			{label: 'Email', fieldName: 'Email__c', Type: 'email'},
			{label: 'Average Grade', fieldName: 'Average_Grade__c', Type: 'decimal'},
			{label: 'Scholarship', fieldName: 'Scholarship__c', Type: 'text'}

		]);
	}
});