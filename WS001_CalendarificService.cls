/**
 * @author Wasim Khadaroo
 * @date 2025-09-02
 * @group Web Service
 * @description Calendarific REST service for ZA holidays
 */
public inherited sharing class WS001_CalendarificService {

    // Use provided assessment API key
    @TestVisible private static String API_KEY = '24c5e86734eb44dc4a962826324a5546e74dc42f';

    private static String apiKey() { return API_KEY; }

    public static List<WRP_Types.Holiday> getZAHolidays(Integer year) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String url = 'https://calendarific.com/api/v2/holidays'
                   + '?country=ZA'
                   + '&year=' + year
                   + '&api_key=' + EncodingUtil.urlEncode(apiKey(), 'UTF-8');
        req.setEndpoint(url);
        req.setTimeout(15000);

        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() < 200 || res.getStatusCode() >= 300) {
            throw new AuraHandledException('Calendar service error: ' + res.getStatus());
        }
        return parse(res.getBody());
    }

    @TestVisible
    private static List<WRP_Types.Holiday> parse(String body) {
        List<WRP_Types.Holiday> out = new List<WRP_Types.Holiday>();
        if (String.isBlank(body)) return out;

        Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(body);
        Map<String, Object> response = (root == null) ? null : (Map<String, Object>) root.get('response');
        if (response == null) return out;

        List<Object> holidays = (List<Object>) response.get('holidays');
        if (holidays == null) return out;

        for (Object o : holidays) {
            Map<String, Object> h = (Map<String, Object>) o;
            WRP_Types.Holiday item = new WRP_Types.Holiday();
            item.name = (String) h.get('name');
            item.description = (String) h.get('description');
            Map<String, Object> dateMap = (Map<String, Object>) h.get('date');
            if (dateMap != null) item.dateIso = (String) dateMap.get('iso');
            List<Object> t = (List<Object>) h.get('type');
            if (t != null) {
                item.type = new List<String>();
                for (Object tv : t) item.type.add((String) tv);
            }

            // Keep banking/public (and national)
            if (item.type == null || item.type.isEmpty()) {
                out.add(item);
            } else {
                String joined = String.join(item.type, ';').toLowerCase();
                if (joined.contains('public') || joined.contains('bank') || joined.contains('national')) {
                    out.add(item);
                }
            }
        }
        return out;
    }
}