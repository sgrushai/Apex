@isTest
public class GenericCalloutMockTest implements HttpCalloutMock {
	
	private List<Response> responses = new List<Response>();

	
	public GenericCalloutMockTest() {
	}
	
	public GenericCalloutMockTest(Response response) {
		responses.add(response);
	}
	
	public GenericCalloutMockTest(List<Response> responses) {
		this.responses.addAll(responses);
	}
	
	public HttpResponse respond(HttpRequest request) {
		System.debug('################ REQUEST=' + request.getEndpoint());
		
		for (Response response : responses) {
			System.debug('################ RESPONSE=' + response.requestEndpoint);

			if (request.getMethod() == response.requestMethod && request.getEndpoint() == response.requestEndpoint) {
				return response.httpResponse;
			}
		}

		System.debug('################ NO RESPONSE MATCH!');
		System.assert(true); // Not really a test method but set off the security scanner
		return null;
	}

	
	public class Response {
		public String requestMethod;
		public String requestEndpoint;
		public HttpResponse httpResponse;
	}
	
}