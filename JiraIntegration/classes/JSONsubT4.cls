public class JSONsubT4 {
	public static void consumeObject(JSONParser parser) {
		Integer depth = 0;
		do {
			JSONToken curr = parser.getCurrentToken();
			if (curr == JSONToken.START_OBJECT || 
				curr == JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == JSONToken.END_OBJECT ||
				curr == JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

	public class Status {
		public String self {get;set;} 
		public String description {get;set;} 
		public String iconUrl {get;set;} 
		public String name {get;set;} 
		public String id {get;set;} 
		public StatusCategory statusCategory {get;set;} 

		public Status(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'self') {
							self = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'iconUrl') {
							iconUrl = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else if (text == 'statusCategory') {
							statusCategory = new StatusCategory(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Status consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class StatusCategory {
		public String self {get;set;} 
		public Integer id {get;set;} 
		public String key {get;set;} 
		public String colorName {get;set;} 
		public String name {get;set;} 

		public StatusCategory(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'self') {
							self = parser.getText();
						} else if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'key') {
							key = parser.getText();
						} else if (text == 'colorName') {
							colorName = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'StatusCategory consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Fields {
		public String summary {get;set;} 
		public Status status {get;set;} 
		public Priority priority {get;set;} 
		public Issuetype issuetype {get;set;} 

		public Fields(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'summary') {
							summary = parser.getText();
						} else if (text == 'status') {
							status = new Status(parser);
						} else if (text == 'priority') {
							priority = new Priority(parser);
						} else if (text == 'issuetype') {
							issuetype = new Issuetype(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Fields consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String expand {get;set;} 
	public Integer startAt {get;set;} 
	public Integer maxResults {get;set;} 
	public Integer total {get;set;} 
	public List<Issues> issues {get;set;} 

	public JSONsubT4(JSONParser parser) {
		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'expand') {
						expand = parser.getText();
					} else if (text == 'startAt') {
						startAt = parser.getIntegerValue();
					} else if (text == 'maxResults') {
						maxResults = parser.getIntegerValue();
					} else if (text == 'total') {
						total = parser.getIntegerValue();
					} else if (text == 'issues') {
						issues = new List<Issues>();
						while (parser.nextToken() != JSONToken.END_ARRAY) {
							issues.add(new Issues(parser));
						}
					} else {
						System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Priority {
		public String self {get;set;} 
		public String iconUrl {get;set;} 
		public String name {get;set;} 
		public String id {get;set;} 

		public Priority(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'self') {
							self = parser.getText();
						} else if (text == 'iconUrl') {
							iconUrl = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Priority consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Issues {
		public String expand {get;set;} 
		public String id {get;set;} 
		public String self {get;set;} 
		public String key {get;set;} 
		public Fields_Z fields {get;set;} 

		public Issues(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'expand') {
							expand = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else if (text == 'self') {
							self = parser.getText();
						} else if (text == 'key') {
							key = parser.getText();
						} else if (text == 'fields') {
							fields = new Fields_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Issues consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Issuetype {
		public String self {get;set;} 
		public String id {get;set;} 
		public String description {get;set;} 
		public String iconUrl {get;set;} 
		public String name {get;set;} 
		public Boolean subtask {get;set;} 

		public Issuetype(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'self') {
							self = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'iconUrl') {
							iconUrl = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'subtask') {
							subtask = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Issuetype consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Subtasks {
		public String id {get;set;} 
		public String key {get;set;} 
		public String self {get;set;} 
		public Fields fields {get;set;} 

		public Subtasks(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'key') {
							key = parser.getText();
						} else if (text == 'self') {
							self = parser.getText();
						} else if (text == 'fields') {
							fields = new Fields(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Subtasks consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Fields_Z {
		public String summary {get;set;} 
		public List<Subtasks> subtasks {get;set;} 
		public String description {get;set;} 
		public Priority priority {get;set;} 
		public String resolution {get;set;} 
		public Status status {get;set;} 

		public Fields_Z(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'summary') {
							summary = parser.getText();
						} else if (text == 'subtasks') {
							subtasks = new List<Subtasks>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								subtasks.add(new Subtasks(parser));
							}
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'priority') {
							priority = new Priority(parser);
						} else if (text == 'resolution') {
							resolution = parser.getText();
						} else if (text == 'status') {
							status = new Status(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Fields_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static JSONsubT4 parse(String json) {
		return new JSONsubT4(System.JSON.createParser(json));
	}
}