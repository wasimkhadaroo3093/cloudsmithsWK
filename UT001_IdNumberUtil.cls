/**
 * @author Wasim Khadaroo
 * @date 2025-09-02
 * @group Utils
 * @description SA ID validation/decoding (date, gender, citizenship) + strict Luhn and DOB checks.
 */
public without sharing class UT001_IdNumberUtil {

    public class DecodedId {
        public Boolean valid;
        public String message;
        public String idNumber;
        public Date dateOfBirth;
        public String gender;     // Male/Female
        public Boolean isCitizen; // true if 11th digit == 0
        public Integer year;      // convenience
    }

    public static DecodedId decode(String raw) {
        DecodedId out = new DecodedId();
        out.idNumber = raw;

        if (String.isBlank(raw)) {
            out.valid = false; out.message = 'ID is blank'; return out;
        }

        // Keep only digits
        String id = raw.replaceAll('[^0-9]', '');
        if (id == null || id.length() != 13) {
            out.valid = false; out.message = 'ID must be 13 digits'; return out;
        }
        // Ensure all numeric
        try { Long.valueOf(id); } catch (Exception e) {
            out.valid = false; out.message = 'ID must contain only digits'; return out;
        }

        // Parse YYMMDD
        Integer yy = Integer.valueOf(id.substring(0, 2));
        Integer mm = Integer.valueOf(id.substring(2, 4));
        Integer dd = Integer.valueOf(id.substring(4, 6));

        // Century
        Integer currYY = Math.mod(Date.today().year(), 100);
        Integer century = (yy <= currYY) ? 2000 : 1900;
        Integer yyyy = century + yy;
        out.year = yyyy;

        // STRICT month/day range checks BEFORE constructing Date
        if (mm < 1 || mm > 12) {
            out.valid = false; out.message = 'Invalid birth date'; return out;
        }
        Integer maxDay = daysInMonth(yyyy, mm);
        if (dd < 1 || dd > maxDay) {
            out.valid = false; out.message = 'Invalid birth date'; return out;
        }

        try {
            out.dateOfBirth = Date.newInstance(yyyy, mm, dd);
        } catch (Exception e) {
            out.valid = false; out.message = 'Invalid birth date'; return out;
        }

        // Gender (7th–10th)
        Integer genderBlock = Integer.valueOf(id.substring(6, 10));
        out.gender = (genderBlock >= 5000) ? 'Male' : 'Female';

        // Citizenship (11th digit)
        Integer citizen = Integer.valueOf(id.substring(10, 11));
        if (citizen != 0 && citizen != 1) {
            out.valid = false; out.message = 'Invalid citizenship digit'; return out;
        }
        out.isCitizen = (citizen == 0);

        // Luhn checksum over all 13 digits
        if (!luhnValid(id)) {
            out.valid = false; out.message = 'The ID number is not valid. Please check and try again.'; return out;
        }

        out.valid = true; out.message = 'OK';
        return out;
    }

    // Luhn over full string (expects only digits)
    public static Boolean luhnValid(String digits) {
        Integer sum = 0;
        Boolean doubleIt = false;
        for (Integer i = digits.length() - 1; i >= 0; i--) {
            Integer n = Integer.valueOf(digits.substring(i, i+1));
            if (doubleIt) {
                n *= 2;
                if (n > 9) n -= 9;
            }
            sum += n;
            doubleIt = !doubleIt;
        }
        return Math.mod(sum, 10) == 0;
    }

    // Strict days-in-month calculation with leap-year support
    private static Integer daysInMonth(Integer year, Integer month) {
        // month: 1..12
        Integer[] md = new Integer[]{31,28,31,30,31,30,31,31,30,31,30,31};
        Boolean leap = (Math.mod(year, 4) == 0) && ((Math.mod(year, 100) != 0) || (Math.mod(year, 400) == 0));
        if (leap) md[1] = 29;
        return md[month - 1];
    }
}