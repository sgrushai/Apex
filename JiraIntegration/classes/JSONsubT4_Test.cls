@IsTest
public class JSONsubT4_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{\"expand\":\"names,schema\",\"startAt\":0,\"maxResults\":2,\"total\":1,\"issues\":[{\"expand\":\"operations,editmeta,changelog,transitions,renderedFields\",\"id\":\"344406\",\"self\":\"https://jira-stage.ontrq.com/rest/api/2/issue/344406\",\"key\":\"SEEEU-594\",\"fields\":{\"summary\":\"Request High Level Estimate\",\"subtasks\":[{\"id\":\"344407\",\"key\":\"SEEEU-595\",\"self\":\"https://jira-stage.ontrq.com/rest/api/2/issue/344407\",\"fields\":{\"summary\":\"TEST1001\",\"status\":{\"self\":\"https://jira-stage.ontrq.com/rest/api/2/status/1\",\"description\":\"The issue is open and ready for the assignee to start work on it.\",\"iconUrl\":\"https://jira-stage.ontrq.com/images/icons/statuses/open.png\",\"name\":\"Open\",\"id\":\"1\",\"statusCategory\":{\"self\":\"https://jira-stage.ontrq.com/rest/api/2/statuscategory/2\",\"id\":2,\"key\":\"new\",\"colorName\":\"blue-gray\",\"name\":\"To Do\"}},\"priority\":{\"self\":\"https://jira-stage.ontrq.com/rest/api/2/priority/3\",\"iconUrl\":\"https://jira-stage.ontrq.com/images/icons/priorities/major.png\",\"name\":\"Major\",\"id\":\"3\"},\"issuetype\":{\"self\":\"https://jira-stage.ontrq.com/rest/api/2/issuetype/5\",\"id\":\"5\",\"description\":\"Sub-Task\",\"iconUrl\":\"https://jira-stage.ontrq.com/images/icons/issuetypes/task.png\",\"name\":\"Sub-Task Task\",\"subtask\":true}}}],\"description\":null,\"priority\":{\"self\":\"https://jira-stage.ontrq.com/rest/api/2/priority/5\",\"iconUrl\":\"https://jira-stage.ontrq.com/images/icons/priorities/trivial.png\",\"name\":\"Trivial\",\"id\":\"5\"},\"resolution\":null,\"status\":{\"self\":\"https://jira-stage.ontrq.com/rest/api/2/status/1\",\"description\":\"The issue is open and ready for the assignee to start work on it.\",\"iconUrl\":\"https://jira-stage.ontrq.com/images/icons/statuses/open.png\",\"name\":\"Open\",\"id\":\"1\",\"statusCategory\":{\"self\":\"https://jira-stage.ontrq.com/rest/api/2/statuscategory/2\",\"id\":2,\"key\":\"new\",\"colorName\":\"blue-gray\",\"name\":\"To Do\"}}}}]}';
		JSONsubT4 r = JSONsubT4.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSONsubT4.Status objStatus = new JSONsubT4.Status(System.JSON.createParser(json));
		System.assert(objStatus != null);
		System.assert(objStatus.self == null);
		System.assert(objStatus.description == null);
		System.assert(objStatus.iconUrl == null);
		System.assert(objStatus.name == null);
		System.assert(objStatus.id == null);
		System.assert(objStatus.statusCategory == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSONsubT4.StatusCategory objStatusCategory = new JSONsubT4.StatusCategory(System.JSON.createParser(json));
		System.assert(objStatusCategory != null);
		System.assert(objStatusCategory.self == null);
		System.assert(objStatusCategory.id == null);
		System.assert(objStatusCategory.key == null);
		System.assert(objStatusCategory.colorName == null);
		System.assert(objStatusCategory.name == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSONsubT4.Fields objFields = new JSONsubT4.Fields(System.JSON.createParser(json));
		System.assert(objFields != null);
		System.assert(objFields.summary == null);
		System.assert(objFields.status == null);
		System.assert(objFields.priority == null);
		System.assert(objFields.issuetype == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSONsubT4 objRoot = new JSONsubT4(System.JSON.createParser(json));
		System.assert(objRoot != null);
		System.assert(objRoot.expand == null);
		System.assert(objRoot.startAt == null);
		System.assert(objRoot.maxResults == null);
		System.assert(objRoot.total == null);
		System.assert(objRoot.issues == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSONsubT4.Priority objPriority = new JSONsubT4.Priority(System.JSON.createParser(json));
		System.assert(objPriority != null);
		System.assert(objPriority.self == null);
		System.assert(objPriority.iconUrl == null);
		System.assert(objPriority.name == null);
		System.assert(objPriority.id == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSONsubT4.Issues objIssues = new JSONsubT4.Issues(System.JSON.createParser(json));
		System.assert(objIssues != null);
		System.assert(objIssues.expand == null);
		System.assert(objIssues.id == null);
		System.assert(objIssues.self == null);
		System.assert(objIssues.key == null);
		System.assert(objIssues.fields == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSONsubT4.Issuetype objIssuetype = new JSONsubT4.Issuetype(System.JSON.createParser(json));
		System.assert(objIssuetype != null);
		System.assert(objIssuetype.self == null);
		System.assert(objIssuetype.id == null);
		System.assert(objIssuetype.description == null);
		System.assert(objIssuetype.iconUrl == null);
		System.assert(objIssuetype.name == null);
		System.assert(objIssuetype.subtask == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSONsubT4.Subtasks objSubtasks = new JSONsubT4.Subtasks(System.JSON.createParser(json));
		System.assert(objSubtasks != null);
		System.assert(objSubtasks.id == null);
		System.assert(objSubtasks.key == null);
		System.assert(objSubtasks.self == null);
		System.assert(objSubtasks.fields == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSONsubT4.Fields_Z objFields_Z = new JSONsubT4.Fields_Z(System.JSON.createParser(json));
		System.assert(objFields_Z != null);
		System.assert(objFields_Z.summary == null);
		System.assert(objFields_Z.subtasks == null);
		System.assert(objFields_Z.description == null);
		System.assert(objFields_Z.priority == null);
		System.assert(objFields_Z.resolution == null);
		System.assert(objFields_Z.status == null);
	}
}