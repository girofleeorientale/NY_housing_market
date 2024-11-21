SELECT p.*
FROM ny_property p
WHERE p.price < 500000
  AND (p.type IS NULL OR p.type <> 'Condo');