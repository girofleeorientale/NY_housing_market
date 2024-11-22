SELECT COUNT(p.beds) AS nb_of_property_w_one_bed
FROM ny_property p
WHERE p.beds = 1;