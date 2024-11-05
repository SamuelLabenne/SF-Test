public with sharing class testClass {
    public testClass() {
       String hello = 'hello world2';

    }

    
    public static void makeCallOut(String name){
        String apiKey = 'xxx';
        String baseUrl = 'https://developer-edition.ap1.force.com/my/'+name+'/key='+apiKey+'';
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(baseUrl);
        request.setTimeout(10000);

        HttpResponse response = h.send(request);
        if(response.getStatusCode() == 200){
            System.System.debug(response.getBody());
        }else{
            System.debug('Error: Status Code ' + response.getStatusCode());
        }

    }
}