SELECT p.*, p.price
FROM ny_property p
JOIN location l ON p.location_id = l.location_id
WHERE l.locality = 'Bronx County' AND p.price < 300000;