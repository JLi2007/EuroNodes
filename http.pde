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

// call the country flags api
String requestHTTPFlag(String c){
    String country = mapToIso2.get(c);

    if(country != null){
       return "https://flagsapi.com/"+country+"/shiny/64.png"; 
    }
    else{
        return null;
    }
}   

// call the pexels api
String requestHTTPImage(String c){
    String pexelsKey = "7oES3VxqNNpE9xjrCYnoKGGKMotGzhL0mE4Tzn66k8cYt6Zv38dPCxcO";
    String pixelsEndpoint = "https://api.pexels.com/v1/search?query=" + c + "%20skyline&per_page=20";

    GetRequest pexelsGet = new GetRequest(pixelsEndpoint);
    pexelsGet.addHeader("Authorization", pexelsKey);
    pexelsGet.send();

    JSONObject response = parseJSONObject(pexelsGet.getContent());

    // access the tiny image url in the json Object data, picks a random object on the page, indicatating a random photo
    String src = response.getJSONArray("photos").getJSONObject(int(random(0,12))).getJSONObject("src").getString("tiny");

    if(src != null){
        println(src);
        return src;
    }
    else{
        return null;
    }
}

PImage loadImageFromURL(String urlString) {
  try {

    // open a java URL connection with the url string
    URL url = new URL(urlString);
    URLConnection connection = url.openConnection();
    
    // due to CORS issues on the API, Processing returns a 403 error when trying to access the urlString it's the actual link
    // requires adding a User Agent to bypass this security
    connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36");

    // connect to the URL
    connection.connect();

    InputStream inputStream = connection.getInputStream();
      
    // create a temporary file to save the image to local
    File tempFile = File.createTempFile("tempImage", ".jpg");

    // delete temp file on program exit
    tempFile.deleteOnExit();
    
    // Write the input stream (image data) to the temporary file
    FileOutputStream outputStream = new FileOutputStream(tempFile);
    byte[] buffer = new byte[4096];
    int bytesRead;
    while ((bytesRead = inputStream.read(buffer)) != -1) {
        outputStream.write(buffer, 0, bytesRead);
    }

    return loadImage(tempFile.getAbsolutePath());

  } catch (Exception e) {
    e.printStackTrace();
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
