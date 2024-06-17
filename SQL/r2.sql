
SELECT
    l.ADDRESS,
    np.BATH,
    np.TYPE
FROM
    ny_property np
JOIN
    location l ON np.LOCATION_ID = l.LOCATION_ID
WHERE
    np.PRICE < 300000 AND np.TYPE = 'Condo';
