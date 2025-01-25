// API CALLS

// call the country flags api
String requestHTTPFlag(String c){
    String country = mapToIso2.get(c);

    if(country != null){
       return "https://flagsapi.com/"+country+"/shiny/64.png"; 
    }else{
        return null;
    }
}   

// call the pexels api
String requestHTTPImage(String c){
    // USUALLY KEPT SECRET (but since theres no risk I'm revealing it here, also for easier integration)
    String pexelsKey = "7oES3VxqNNpE9xjrCYnoKGGKMotGzhL0mE4Tzn66k8cYt6Zv38dPCxcO";

    // special case for united kingdom as the query hates spaces
    if(c.equals("United Kingdom")){
        c = "U.K";
    }

    // create the endpoint
    String pixelsEndpoint = "https://api.pexels.com/v1/search?query=" + c + "%20famous&per_page=20";

    // use get request and add the api key to retreive images from the api
    GetRequest pexelsGet = new GetRequest(pixelsEndpoint);
    pexelsGet.addHeader("Authorization", pexelsKey);
    pexelsGet.send();

    // parse the JSOn object into a processing JSON object to access the data easier
    JSONObject response = parseJSONObject(pexelsGet.getContent());

    // go into the JSON data and pick out a random "tiny" photo from the search query
    String src = response.getJSONArray("photos").getJSONObject(int(random(0,20))).getJSONObject("src").getString("tiny");

    // return it
    if(src != null){
        println("Here is your link " + src);
        return src;
    }else{
        return null;
    }
}

// load an image from URL (for the pexels api as security issues prevent the 'loadImage()' function from working without a indicating 'user-agents')
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

    // reads url into an array of bytes
    InputStream inputStream = connection.getInputStream();
      
    // create a temporary file to save the image to local
    File tempFile = File.createTempFile("tempImage", ".jpg");

    // delete temp file on program exit
    tempFile.deleteOnExit();
    
    // setup the output stream, linking it to the temporary file
    FileOutputStream outputStream = new FileOutputStream(tempFile);

    // create a byte array
    byte[] buffer = new byte[4096];
    int bytesRead;
    // write the input stream (image bytes) to the temporary file
    while ((bytesRead = inputStream.read(buffer)) != -1) {
        outputStream.write(buffer, 0, bytesRead);
    }

    // now load the image, as the file is written to bytes on local, bypassing the security issues
    return loadImage(tempFile.getAbsolutePath());

  } catch (Exception e) {
    e.printStackTrace();
    return null;
  }
}

// populate the hashmap
void httpSetup(){
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
    mapToIso2.put("Denmark", "DK");
    mapToIso2.put("Netherlands", "NL");
    mapToIso2.put("Switzerland", "CH");
    mapToIso2.put("Belgium", "BE");
}