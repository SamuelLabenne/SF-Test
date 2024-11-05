@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody('{"main": {"temp": 20.5}, "weather": [{"description": "clear sky"}]}');
        return response;
    }
}