SELECT p.*
FROM ny_property p
JOIN location l ON p.LOCATION_ID = l.LOCATION_ID
JOIN ny_broker b ON p.BROKER_ID = b.BROKER_ID
WHERE p.PRICE < 300000 AND p.TYPE = 'Condo';
