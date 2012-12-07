
-- Remove all entries without a Username
DELETE FROM mysql.user WHERE User='';

-- Remove all entries without a Password
DELETE FROM mysql.user WHERE Password='';

-- Drop the Test Database
DROP DATABASE IF EXISTS test;

FLUSH privileges;
