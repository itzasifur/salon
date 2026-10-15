CREATE TABLE IF NOT EXISTS customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR UNIQUE NOT NULL,
  name VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  service_id INT NOT NULL REFERENCES services(service_id),
  time VARCHAR NOT NULL
);

INSERT INTO services (name)
SELECT service_name
FROM (VALUES
  (1, 'cut'),
  (2, 'color'),
  (3, 'perm'),
  (4, 'style'),
  (5, 'trim')
) AS default_services(service_order, service_name)
WHERE NOT EXISTS (
  SELECT 1
  FROM services
  WHERE services.name = default_services.service_name
)
ORDER BY service_order;