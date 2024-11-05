public with sharing class WeatherService {
    private static final String BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
    private static final String API_KEY = '1f2397b81c75519ca739088618a4cc7d';
    

    @AuraEnabled
    public static Weather_Record__c getWeatherByCity(String cityName){
        Weather_Record__c weatherRecord = new Weather_Record__c();
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(BASE_URL + '?q=' + EncodingUtil.urlEncode(cityName, 'UTF-8') + '&appid=' + API_KEY + '&units=metric');
            //request.setEndpoint(BASE_URL + '?q=' + EncodingUtil.urlEncode(cityName, 'UTF-8') + '&units=metric');
            request.setMethod('GET');

            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                
                // Parse JSON response
                Map<String, Object> mainData = (Map<String, Object>) result.get('main');
                List<Object> weatherList = (List<Object>) result.get('weather');
                Map<String, Object> weatherInfo = (Map<String, Object>) weatherList[0];

                // Populate custom object fields
                weatherRecord.City__c = cityName;
                weatherRecord.Temperature__c = (Decimal) mainData.get('temp');
                weatherRecord.Weather_Description__c = (String) weatherInfo.get('description');
                weatherRecord.Date__c = Date.today();

                // Insert the weather record
                insert weatherRecord;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return weatherRecord;
    }
}
