SELECT l.address, p.beds > 3 AS more_than_three_beds
FROM ny_property p
JOIN location l ON p.location_id = l.location_id
WHERE l.locality = 'New York';