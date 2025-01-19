// populate the hashmap
void httpSetup(){
    mapToIso2 = new HashMap<String, String>();
    mapToIso2.put("Russia", "RU");
    mapToIso2.put("Ukraine", "UA");
    mapToIso2.put("France", "FR");
    mapToIso2.put("Spain", "ES");
    mapToIso2.put("Sweden", "SE");
    mapToIso2.put("Germany", "DE");
    mapToIso2.put("Finland", "FI");
    mapToIso2.put("Norway", "NO");
    mapToIso2.put("Poland", "PL");
    mapToIso2.put("Italy", "IT");
    mapToIso2.put("United Kingdom", "GB");
    mapToIso2.put("Romania", "RO");
    mapToIso2.put("Belarus", "BY");
    mapToIso2.put("Greece", "GR");
    mapToIso2.put("Bulgaria", "BG");
    mapToIso2.put("Iceland", "IS");
    mapToIso2.put("Hungary", "HU");
    mapToIso2.put("Portugal", "PT");
    mapToIso2.put("Austria", "AT");
    mapToIso2.put("Czechia", "CZ");
    mapToIso2.put("Serbia", "RS");
    mapToIso2.put("Ireland", "IE");
    mapToIso2.put("Lithuania", "LT");
    mapToIso2.put("Latvia", "LV");
    mapToIso2.put("Netherlands", "NL");
    mapToIso2.put("Belgium", "BE");
    mapToIso2.put("Europe", "EU");
}

String requestHTTPData(String c){
    String country = mapToIso2.get(c);
    if(country != null){
        return "https://flagsapi.com/"+country+"/shiny/64.png";
    }
    else{
        return null;
    }

}   


    // // endpoints
    // String populationEndpoint = "https://countriesnow.space/api/v0.1/countries/population"; ///q?iso3=NGA
    // String unicodeFlagEndpoint = "https://countriesnow.space/api/v0.1/countries/flag/unicode";
    // String urlFlagEndpoint = "https://countriesnow.space/api/v0.1/countries/flag/images";

    // PostRequest populationPost = new PostRequest(populationEndpoint);
    // populationPost.addHeader("Accept", "application/json");
    // populationPost.addHeader("Content-Type", "application/json");
    
    // String jsonBody = "{ \"iso3\": \"NGA\" }";
    // populationPost.setBody(jsonBody);
    // populationPost.send();
    // println(populationPost.getContent());
