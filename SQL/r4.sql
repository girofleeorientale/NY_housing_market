SELECT l.ADDRESS, p.PROPERTYSQFT
FROM ny_property p
JOIN location l ON p.LOCATION_ID = l.LOCATION_ID
WHERE l.locality = 'Kings County'
  AND NOT EXISTS (
    SELECT 1
    FROM ny_property p_2
    WHERE p_2.location_id = p.location_id
      AND p_2.propertysqft < 100000
      AND p_2.bath < 10
);